import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/controller/customer_info_controller.dart';
import 'package:ocean_sys/gen/assets.gen.dart';

class CustomerPage extends StatelessWidget {
  CustomerPage({super.key});

  CustomerInfoController customerInfoController = Get.put(
    CustomerInfoController(),
  );
  @override
  Widget build(BuildContext context) {
    final int index = Get.arguments ?? 0;
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
                        'نام مشتری : ${customerInfoController.custmerinfolist[index].customerBoard} ',
                        style: MyTextStyle.textBlack16,
                      ),
                      SizedBox(height: 4),
                      Text(
                        ' نام مالک : ${customerInfoController.custmerinfolist[index].customerName}',
                        style: MyTextStyle.textSmall12,
                      ),
                      Text(
                        'وضعیت  : ${customerInfoController.custmerinfolist[index].status}',
                        style: MyTextStyle.textSmall12,
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
                    'شماره همراه : ${customerInfoController.custmerinfolist[index].mobile}',
                    style: MyTextStyle.textSmall12,
                  ),
                  Text(
                    'شماره همراه : ${customerInfoController.custmerinfolist[index].phone}',
                    style: MyTextStyle.textSmall12,
                  ),
                  Text(
                    ' محدوده  : ${customerInfoController.custmerinfolist[index].area}',
                    style: MyTextStyle.textSmall12,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'آدرس  : ${customerInfoController.custmerinfolist[index].address}',
                style: MyTextStyle.textSmall12,
                maxLines: 2,
              ),
              SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    ' کد ملی : ${customerInfoController.custmerinfolist[index].nationalCode}',
                    style: MyTextStyle.textSmall12,
                  ),
                  Text(
                    ' کد پستی : ${customerInfoController.custmerinfolist[index].postalCode}',
                    style: MyTextStyle.textSmall12,
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
                      onPressed: () {
                        sendDisActive();
                      },
                      child: Text(
                        "غیر فعال کردن مشتری",
                        style: MyTextStyle.bottomstyle,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      style: MyDecorations.mainButtom,

                      onPressed: () {},
                      child: Text(
                        "اصلاح اطلاعات",
                        style: MyTextStyle.bottomstyle,
                      ),
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
                      child: Text(
                        "شکایت مشتری",
                        style: MyTextStyle.bottomstyle,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      style: MyDecorations.mainButtom,

                      onPressed: () {},
                      child: Text(
                        "ماهیت خرید مشتری",
                        style: MyTextStyle.bottomstyle,
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

  // غیر فعال سازی مشتری
  void sendDisActive() {
    String? selectedReason;
    List<String> reasons = [
      'عدم همکاری مشتری',
      'تغییر مالکیت',
      'تغییر آدرس',
      'سایر',
    ];
    Get.defaultDialog(
      title: "دلیل غیر فعال سازی",
      titleStyle: MyTextStyle.textBlack16,
      content: Column(
        children: [
          DropdownButtonFormField<String>(
            value: selectedReason,
            hint: Text("یک دلیل را انتخاب کنید", style: MyTextStyle.textBlak12),
            items: reasons.map((reason) {
              return DropdownMenuItem(
                child: Text(reason, style: TextStyle(fontSize: 12)),
                value: reason,
              );
            }).toList(),
            onChanged: (value) {
              selectedReason = value;
            },
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: "توضیحات بیشتر",
              labelStyle: MyTextStyle.textBlak12,
              border: OutlineInputBorder(),
              focusColor: SolidColors.listCustomerColor,
            ),
            style: MyTextStyle.textBlak12,
            maxLines: 4,
          ),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () {
          // TODO باید دلیل غیر فعال سازی اینجا ارسال بسه
        },

        style: MyDecorations.mainButtom,
        child: Text("تایید", style: MyTextStyle.bottomstyle),
      ),
    );
  }
}
