import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_bloc.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_event.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_state.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/customer_page.dart';
import 'package:ocean_sys/view/RouteScanner/map/bloc/location_sync/location_sync_bloc.dart';
import 'package:ocean_sys/view/RouteScanner/map/bloc/location_sync/location_sync_state.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final LocationSyncBloc _locationSyncBloc;
  final MapController _mapController = MapController();
  bool _isCenteredOnUser = false;

  @override
  void initState() {
    super.initState();
    _locationSyncBloc = context.read<LocationSyncBloc>();
    _locationSyncBloc.add(
      StartFastUpdates(
        androidInterval: const Duration(seconds: 5),
        distanceFilter: 0,
      ),
    );
  }

  @override
  void dispose() {
    _locationSyncBloc.add(StopFastUpdates());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LocationSyncBloc, LocationSyncState>(
        listener: (context, locationState) {
          final hasUser = locationState.lat != 0.0 && locationState.long != 0.0;
          if (hasUser && !_isCenteredOnUser) {
            _isCenteredOnUser = true;
            _mapController.move(
              LatLng(locationState.lat, locationState.long),
              15.0,
            );
          }
        },
        builder: (context, locationState) {
          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(35.6892, 51.3890),
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://mt1.google.com/vt/lyrs=r&x={x}&y={y}&z={z}',
                userAgentPackageName: 'com.yourcompany.ocean_sys',
                tileProvider: NetworkTileProvider(),
              ),
              BlocBuilder<CustomerInfoBloc, CustomerInfoState>(
                builder: (context, customerState) {
                  final markers = <Marker>[];

                  // Customer markers
                  if (customerState is CustomerInfoLoaded) {
                    final customerPoints = context
                        .read<CustomerInfoBloc>()
                        .getPoints(customerState.customers);

                    // Debug print customer points
                    print(
                      "=== Customer Markers (${customerPoints.length}) ===",
                    );
                    for (var point in customerPoints) {
                      print("- ${point['name']}: ${point['location']}");
                    }

                    markers.addAll(
                      customerPoints.map((point) {
                        final markerColor = point['isvusit'] == 1
                            ? SolidColors.pointVisitColor
                            : point['isvusit'] == 2
                            ? SolidColors.pointNoSendEndJab
                            : SolidColors.pointNoVisitColor;
                        return Marker(
                          point: point['location'],
                          width: 80,
                          height: 70,
                          alignment: Alignment.topCenter,
                          child: GestureDetector(
                            onTap: () async {
                              final customerIndex = point['index'] as int?;
                              if (customerIndex != null) {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CustomerPage(index: customerIndex),
                                  ),
                                );
                                if (context.mounted) {
                                  context.read<CustomerInfoBloc>().add(
                                    CustomerInfoFetchData(),
                                  );
                                }
                              }
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: markerColor,
                                      size: 40,
                                      shadows: const [],
                                    ),
                                    Positioned(
                                      top: 8,
                                      child: Icon(
                                        Icons.storefront,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    point['name'],
                                    style: MyTextStyle.lebelMap,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }

                  // User marker
                  final hasUser =
                      locationState.lat != 0.0 && locationState.long != 0.0;

                  // Debug print user marker
                  print("=== User Marker ===");
                  print("- hasUser: $hasUser");
                  print(
                    "- location: (${locationState.lat}, ${locationState.long})",
                  );

                  if (hasUser) {
                    markers.add(
                      Marker(
                        point: LatLng(locationState.lat, locationState.long),
                        width: 60,
                        height: 60,
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: SolidColors.primaryColor.withOpacity(
                                  0.2,
                                ),
                              ),
                            ),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: SolidColors.primaryColor,
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Debug print all markers
                  print("=== Total Markers: ${markers.length} ===");
                  for (var i = 0; i < markers.length; i++) {
                    print("- Marker $i: ${markers[i].point}");
                  }

                  return MarkerLayer(markers: markers);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
