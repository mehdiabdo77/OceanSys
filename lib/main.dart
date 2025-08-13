import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/login_page.dart';
import 'package:ocean_sys/splash_screen.dart';
import 'package:ocean_sys/view/customer%20_page.dart';
import 'package:ocean_sys/view/customer_page_idit.dart';
import 'package:ocean_sys/view/main_screen.dart';
import 'package:ocean_sys/view/map_page.dart';

void main() async {
  await GetStorage.init();
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
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: NamedRoute.loginPage, page: () => LoginPage()),
        GetPage(name: NamedRoute.mapPage, page: () => MapPage()),
        GetPage(name: NamedRoute.homepage, page: () => MainScreen()),
        GetPage(name: NamedRoute.customerPage, page: () => CustomerPage()),
        GetPage(
          name: NamedRoute.customerPageIdit,
          page: () => CustomerPageIdit(),
        ),
      ],

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

class NamedRoute {
  NamedRoute._();
  static String splashScreen = "/";
  static String loginPage = "/loginPage";
  static String customerPage = "/customerPage";
  static String homepage = "/homePage";
  static String mapPage = "/mapPage";
  static String customerPageIdit = "/customerPageIdit";
}
