import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/gen/assets.gen.dart';
import 'package:ocean_sys/route_manager/names.dart';
import 'package:ocean_sys/servies/customer_service.dart';
import 'package:ocean_sys/view/widgets/menuWidget.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu", style: MyTextStyle.appBarStyle)),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          MenuItem(
            svgPath: Assets.icons.customerScan.path,
            title: "scan customer",
            subtitle: "بازرسی مشتریان مسیر",
            onTap: () {
              Get.toNamed(NamedRoute.homepage);
            },
          ),
          MenuItem(
            svgPath: Assets.icons.upload.path,
            title: "upload data",
            subtitle: "ارسال اطلاعات ارسال نشده",

            onTap: () {
              CustomerService().sendOfflineRequest();
            },
          ),
        ],
      ),
    );
  }
}
