import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ocean_sys/constans/permission_constans.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/controller/user_controller.dart';
import 'package:ocean_sys/gen/assets.gen.dart';
import 'package:ocean_sys/route_manager/names.dart';
import 'package:ocean_sys/servies/customer_service.dart';
import 'package:ocean_sys/view/widgets/menuWidget.dart';

class MenuPage extends StatelessWidget {
  var userController = Get.put<UserController>(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu", style: MyTextStyle.appBarStyle)),
      body: Obx(() {
        final user = userController.user.value;
        if (user == null) {
          return Center(child: CircularProgressIndicator());
        }
        return GridView.count(
          crossAxisCount: 2,
          children: [
            if (userController.checkPermission(PermissionConstans.customerScan))
              MenuItem(
                svgPath: Assets.icons.customerScan.path,
                title: "scan customer",
                subtitle: "بازرسی مشتریان مسیر",
                onTap: () {
                  Get.toNamed(NamedRoute.homepage);
                },
              ),
            if (userController.checkPermission(PermissionConstans.uploadData))
              MenuItem(
                svgPath: Assets.icons.upload.path,
                title: "upload data",
                subtitle: "ارسال اطلاعات ارسال نشده",

                onTap: () {
                  CustomerService().sendOfflineRequest();
                },
              ),
            if (userController.checkPermission(PermissionConstans.userManage))
              MenuItem(
                svgPath: Assets.icons.userManager.path,
                title: "USER",
                subtitle: "مدیریت کاربران",
                onTap: () {},
              ),
            if (userController.checkPermission(PermissionConstans.newCustomer))
              MenuItem(
                svgPath: Assets.icons.storeAdd.path,
                title: "New Customer",
                subtitle: "اضافه کردن کاربران جدید",

                onTap: () {},
              ),
            if (userController.checkPermission(
              PermissionConstans.competitorPrices,
            ))
              MenuItem(
                svgPath: Assets.icons.competitorPrices.path,
                title: "Competitor Prices",
                subtitle: "استعلام قیمت رقبا",

                onTap: () {},
              ),
          ],
        );
      }),
    );
  }
}
