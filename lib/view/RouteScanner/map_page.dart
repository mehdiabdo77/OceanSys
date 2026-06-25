import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/cubit/customer_info/customer_info_bloc.dart';
import 'package:ocean_sys/cubit/customer_info/customer_info_state.dart';
import 'package:ocean_sys/cubit/location_sync/location_sync_bloc.dart';
import 'package:ocean_sys/cubit/location_sync/location_sync_state.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
    context.read<LocationSyncBloc>().add(
      StartFastUpdates(
        androidInterval: const Duration(seconds: 5),
        distanceFilter: 0,
      ),
    );
  }

  @override
  void dispose() {
    context.read<LocationSyncBloc>().add(StopFastUpdates());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(35.6892, 51.3890),
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://mt1.google.com/vt/lyrs=r&x={x}&y={y}&z={z}',
            userAgentPackageName: 'com.yourcompany.ocean_sys',
            tileProvider: NetworkTileProvider(),
          ),
          BlocBuilder<CustomerInfoBloc, CustomerInfoState>(
            builder: (context, customerState) {
              return BlocBuilder<LocationSyncBloc, LocationSyncState>(
                builder: (context, locationState) {
                  final markers = <Marker>[];

                  // Customer markers
                  if (customerState is CustomerInfoLoaded) {
                    markers.addAll(
                      context
                          .read<CustomerInfoBloc>()
                          .getPoints(customerState.customers)
                          .map((point) {
                            final markerColor = point['isvusit'] == 1
                                ? SolidColors.pointVisitColor
                                : point['isvusit'] == 2
                                ? SolidColors.pointNoSendEndJab
                                : SolidColors.pointNoVisitColor;
                            return Marker(
                              point: point['location'],
                              width: 140,
                              height: 70,
                              alignment: Alignment.topCenter,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: markerColor,
                                        size: 40,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
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
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      point['name'],
                                      style: MyTextStyle.lebelMap,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
                          .toList(),
                    );
                  }

                  // User marker
                  final hasUser =
                      locationState.lat != 0.0 && locationState.long != 0.0;
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

                  return MarkerLayer(markers: markers);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
