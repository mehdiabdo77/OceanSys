import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/controller/customer_info_controller.dart';
import 'package:ocean_sys/controller/customer_edit_controller.dart';
import 'package:ocean_sys/controller/main_controler.dart';
import 'package:ocean_sys/view/CustomerPages/customer_list_page.dart';
import 'package:ocean_sys/view/map_page.dart';

class MainScreen extends StatelessWidget {
  CustomerInfoController customerInfoController = Get.put(
    CustomerInfoController(),
  );
  CustomerEditController customerEditController = Get.put(
    CustomerEditController(),
  );
  MainControler mainControler = Get.put(MainControler());
  List pages = [CustomerListPage(), MapPage()];
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          actions: [
            GestureDetector(
              onTap: () {
                customerEditController.sendOfflineRequest();
              },
              child: Icon(Icons.refresh_sharp),
            ),
          ],
          backgroundColor: SolidColors.appBorColor,
          toolbarHeight: 40,
        ),
        body: pages[mainControler.currentIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: mainControler.currentIndex.value,
          onTap: mainControler.changePage,
          backgroundColor: SolidColors.bottomNav,

          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list_rounded),
              label: "List Customer",
              backgroundColor: Colors.amber,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on_rounded),
              label: "loction",
            ),
          ],
        ),
      ),
    );
  }
}
