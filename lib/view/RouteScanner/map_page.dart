import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/controller/RouteScannerController/customer_info_controller.dart';
import 'package:ocean_sys/controller/location_sync_controller.dart';

class MapPage extends StatefulWidget {
  MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  CustomerInfoController customerInfoController = Get.put(
    CustomerInfoController(),
  );

  // گرفتن/ثبت کنترلر لوکیشن
  final LocationSyncController locationSyncController =
      Get.isRegistered<LocationSyncController>()
      ? Get.find<LocationSyncController>()
      : Get.put(LocationSyncController());

  @override
  void initState() {
    super.initState();
    // فقط وقتی روی صفحه نقشه‌ایم، آپدیت سریع را روشن کن
    locationSyncController.startFastUpdates(
      androidInterval: const Duration(seconds: 5),
      distanceFilter: 0,
    );
  }

  @override
  void dispose() {
    // خروج از صفحه: آپدیت سریع را خاموش کن
    locationSyncController.stopFastUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(35.6892, 51.3890),
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://mt1.google.com/vt/lyrs=r&x={x}&y={y}&z={z}', // lyrs=r = roadmap
            userAgentPackageName: 'com.yourcompany.ocean_sys',
            tileProvider: NetworkTileProvider(),
          ),
          // لایه مارکرها را واکنشی کردیم تا با تغییر مختصات کاربر، به‌روز شود
          Obx(() {
            final markers = <Marker>[];

            // مارکرهای مشتریان
            markers.addAll(
              customerInfoController.getPoint().map((point) {
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
                        child: Text(point['name'], style: MyTextStyle.lebelMap),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );

            // مارکر کاربر (فقط اگر مختصات معتبر باشد)
            final hasUser =
                locationSyncController.lat != 0.0 &&
                locationSyncController.long != 0.0;
            if (hasUser) {
              markers.add(
                Marker(
                  point: LatLng(
                    locationSyncController.lat,
                    locationSyncController.long,
                  ),
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
          }),
        ],
      ),
    );
  }
}
