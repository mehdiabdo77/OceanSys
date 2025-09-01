import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:ocean_sys/login_page.dart';
import 'package:ocean_sys/route_manager/names.dart';
import 'package:ocean_sys/splash_screen.dart';
import 'package:ocean_sys/view/CustomerPages/customer_page.dart';
import 'package:ocean_sys/view/CustomerPages/customer_page_idit.dart';
import 'package:ocean_sys/view/main_screen.dart';
import 'package:ocean_sys/view/map_page.dart';

class Pages {
  Pages._();

  static List<GetPage<dynamic>> pages = [
    GetPage(name: '/', page: () => SplashScreen()),
    GetPage(name: NamedRoute.loginPage, page: () => LoginPage()),
    GetPage(name: NamedRoute.mapPage, page: () => MapPage()),
    GetPage(name: NamedRoute.homepage, page: () => MainScreen()),
    GetPage(name: NamedRoute.customerPage, page: () => CustomerPage()),
    GetPage(name: NamedRoute.customerPageIdit, page: () => CustomerPageIdit()),
  ];
}
