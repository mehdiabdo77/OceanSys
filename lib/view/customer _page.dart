import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ocean_sys/controller/customer_info_controller.dart';
import 'package:ocean_sys/gen/assets.gen.dart';

class CustomerPage extends StatelessWidget {
  CustomerPage({super.key});

  CustomerInfoController customerInfoController = Get.put(
    CustomerInfoController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                ImageIcon(Image.asset(Assets.icons.store.path).image, size: 50),
                Text(
                  customerInfoController.custmerinfolist[1].customerBoard,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
