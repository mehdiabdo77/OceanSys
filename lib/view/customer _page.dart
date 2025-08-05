import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/controller/customer_info_controller.dart';
import 'package:ocean_sys/gen/assets.gen.dart';

class CustomerPage extends StatelessWidget {
  CustomerPage({super.key});

  CustomerInfoController customerInfoController = Get.put(
    CustomerInfoController(),
  );
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: SolidColors.homepage,
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: SolidColors.appBorColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Icon(Icons.location_on_sharp)],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                children: [
                  ImageIcon(
                    Image.asset(Assets.icons.store.path).image,
                    color: SolidColors.iconmain,
                    size: 60,
                  ),
                  SizedBox(width: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'نام مشتری : ${customerInfoController.custmerinfolist[1].customerBoard} ',
                        style: textTheme.titleLarge,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'کد مشتری : ${customerInfoController.custmerinfolist[1].customerCode}',
                        style: textTheme.bodySmall,
                      ),
                      Text(
                        'محدوده  : ${customerInfoController.custmerinfolist[1].area}',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'شماره همراه : ${customerInfoController.custmerinfolist[1].mobile}',
                    style: textTheme.bodySmall,
                  ),
                  Text(
                    'شماره همراه : ${customerInfoController.custmerinfolist[1].phone}',
                    style: textTheme.bodySmall,
                  ),
                  Text(
                    ' نام مالک : ${customerInfoController.custmerinfolist[1].customerName}',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'آدرس  : ${customerInfoController.custmerinfolist[1].address}',
                style: textTheme.labelMedium,
              ),
              SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    ' کد ملی : ${customerInfoController.custmerinfolist[1].nationalCode}',
                    style: textTheme.bodySmall,
                  ),
                  Text(
                    ' کد پستی : ${customerInfoController.custmerinfolist[1].postalCode}',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
              SizedBox(height: 15),
              // ... existing code ...
              SizedBox(height: 15),
              Divider(thickness: 1, color: Colors.black),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      style: MyDecorations.mainButtom,
                      onPressed: () {},
                      child: Text(
                        "غیر فعال کردن مشتری",
                        style: textTheme.bodySmall,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      style: MyDecorations.mainButtom,

                      onPressed: () {},
                      child: Text("اصلاح اطلاعات", style: textTheme.bodySmall),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      style: MyDecorations.mainButtom,
                      onPressed: () {},
                      child: Text("شکایت مشتری", style: textTheme.bodySmall),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      style: MyDecorations.mainButtom,

                      onPressed: () {},
                      child: Text(
                        "ماهیت خرید مشتری",
                        style: textTheme.bodySmall,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
