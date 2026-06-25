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
                            return Marker(
                              point: point['location'],
                              width: 120,
                              height: 50,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: point['isvusit'] == 1
                                        ? SolidColors.pointVisitColor
                                        : point['isvusit'] == 2
                                        ? SolidColors.pointNoSendEndJab
                                        : SolidColors.pointNoVisitColor,
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 2,
                                          offset: Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      point['name'],
                                      style: MyTextStyle.lebelMap,
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
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.circle,
                              color: Colors.blueAccent,
                              size: 20,
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
