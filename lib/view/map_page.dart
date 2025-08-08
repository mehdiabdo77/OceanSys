import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/controller/customer_info_controller.dart';

class MapPage extends StatefulWidget {
  MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final List<Map<String, dynamic>> fakePoints = const [
    {'name': 'فروشگاه رضا', 'location': LatLng(35.6892, 51.3890)},
    {'name': 'عمده  تهران', 'location': LatLng(35.6935, 51.4020)},
    {'name': 'سوپر امید', 'location': LatLng(35.6870, 51.3815)},
  ];

  CustomerInfoController customerInfoController = Get.put(
    CustomerInfoController(),
  );

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
          MarkerLayer(
            markers: customerInfoController.getPoint().map((point) {
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
                          : SolidColors.pointNoVisitColor,
                      size: 24,
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
          ),
        ],
      ),
    );
  }
}
