import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/controller/customer_edit_controller.dart';
import 'package:ocean_sys/controller/customer_info_controller.dart';

class CustomerPageIdit extends StatelessWidget {
  CustomerPageIdit({super.key});

  CustomerEditController customerEditController = Get.put(
    CustomerEditController(),
  );

  CustomerInfoController customerInfoController = Get.put(
    CustomerInfoController(),
  );

  @override
  Widget build(BuildContext context) {
    final int index = Get.arguments ?? 0;
    return Scaffold(
      backgroundColor: SolidColors.homepage,
      appBar: AppBar(
        toolbarHeight: 45,
        title: Text("ویرایش اطلاعات مشتری", style: MyTextStyle.textBlack16),
        backgroundColor: SolidColors.appBorColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              myTextField(
                "کد ملی",
                customerEditController.nationalCode,
                customerInfoController.custmerinfolist[index].nationalCode,
              ),
              SizedBox(height: 10),
              myTextField("کد نقش", customerEditController.roleCode, ''),
              SizedBox(height: 10),
              myTextField(
                "کد پستی",
                customerEditController.postalCode,
                customerInfoController.custmerinfolist[index].postalCode,
              ),
              SizedBox(height: 10),
              myTextField(
                "نام مالک",
                customerEditController.ownerName,
                customerInfoController.custmerinfolist[index].customerName,
              ),
              SizedBox(height: 10),
              myTextField(
                "نام تابلو مغازه",
                customerEditController.storeName,
                customerInfoController.custmerinfolist[index].customerBoard,
              ),
              SizedBox(height: 10),
              myTextField(
                "شماره همراه",
                customerEditController.mobileNumber,
                customerInfoController.custmerinfolist[index].mobile,
              ),
              SizedBox(height: 10),
              myTextField(
                "شماره همراه 2",
                customerEditController.mobileNumber2,
                '',
              ),
              SizedBox(height: 10),
              myTextField(
                "شماره ثابت",
                customerEditController.phoneNumber,
                customerInfoController.custmerinfolist[index].phone,
              ),
              SizedBox(height: 10),
              myTextField("متراژ مغازه", customerEditController.storeArea, ''),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: MyDecorations.mainButtom,
                child: Text("ذخیره تغییرات", style: MyTextStyle.bottomstyle),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myTextField(
    String labelText,
    TextEditingController controller,
    String title,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("$labelText:"),
            SizedBox(width: 5),
            Text(title, style: MyTextStyle.textSmall12),
          ],
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: MyTextStyle.textBlak12,
            border: OutlineInputBorder(),
            focusColor: SolidColors.listCustomerColor,
          ),
          style: MyTextStyle.textBlak12,
          maxLines: 1,
        ),
      ],
    );
  }
}
