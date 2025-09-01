import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/controller/location_sync_controller.dart';
import 'package:ocean_sys/route_manager/names.dart';
import 'package:ocean_sys/route_manager/pages.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(LocationSyncController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: Locale("fa"),
      initialRoute: NamedRoute.splashScreen,
      debugShowCheckedModeBanner: false,
      getPages: Pages.pages,

      theme: ThemeData(
        fontFamily: "dona",
        textTheme: TextTheme(
          titleLarge: TextStyle(color: Colors.black87, fontSize: 18),
          bodyLarge: TextStyle(
            color: Colors.white,
            fontSize: 15,
            overflow: TextOverflow.ellipsis,
            fontFamily: "dona",
          ),
          bodyMedium: TextStyle(
            color: Colors.black,
            fontSize: 12,
            overflow: TextOverflow.ellipsis,
            fontFamily: "dona",
          ),
          bodySmall: TextStyle(
            color: Colors.white,
            fontSize: 12,
            overflow: TextOverflow.ellipsis,
            fontFamily: "dona",
          ),
          labelMedium: TextStyle(
            color: Colors.black,
            fontSize: 13,
            overflow: TextOverflow.ellipsis,
            fontFamily: "dona",
          ),
          labelSmall: TextStyle(color: Colors.black87, fontSize: 10),
          // رنگ لیست مشتری
        ),
      ),
    );
  }
}
