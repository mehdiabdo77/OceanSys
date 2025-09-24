import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:ocean_sys/view/login_page.dart';
import 'package:ocean_sys/route_manager/names.dart';
import 'package:ocean_sys/view/menu_page%20.dart';
import 'package:ocean_sys/view/splash_screen.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/customer_page.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/customer_page_idit.dart';
import 'package:ocean_sys/view/RouteScanner/route_scanner.dart';
import 'package:ocean_sys/view/RouteScanner/map_page.dart';

class Pages {
  Pages._();

  static List<GetPage<dynamic>> pages = [
    GetPage(name: '/', page: () => SplashScreen()),
    GetPage(name: NamedRoute.loginPage, page: () => LoginPage()),
    GetPage(name: NamedRoute.mapPage, page: () => MapPage()),
    GetPage(name: NamedRoute.homepage, page: () => MainScreen()),
    GetPage(name: NamedRoute.customerPage, page: () => CustomerPage()),
    GetPage(name: NamedRoute.customerPageIdit, page: () => CustomerPageIdit()),
    GetPage(name: NamedRoute.menuPage, page: () => MenuPage()),
  ];
}
