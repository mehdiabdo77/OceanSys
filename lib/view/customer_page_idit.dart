import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/controller/customer_edit_controller.dart';
import 'package:ocean_sys/controller/customer_info_controller.dart';

class CustomerPageIdit extends StatelessWidget {
  CustomerPageIdit({super.key});
  final _formKey = GlobalKey<FormState>();

  final RegExp _mobileReg = RegExp(r'^09\d{9}$'); // موبایل
  final RegExp _phoneReg = RegExp(r'^(021|026)\d{8}$'); // تلفن ثابت
  final RegExp _tenDigits = RegExp(r'^\d{10}$'); // عدد ها

  String? _validator(RegExp pattern, String label, String v) {
    if (!pattern.hasMatch(v)) {
      return "$label فرمت صحیح ندارد";
    } else {
      return null;
    }
  }

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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                myTextField(
                  "کد ملی",
                  customerEditController.nationalCode,
                  customerInfoController.custmerinfolist[index].nationalCode,

                  validator: (v) {
                    if (v == null || v.isEmpty) return null;
                    return _validator(_tenDigits, "کد ملی", v);
                  },
                  inputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                SizedBox(height: 10),
                myTextField("کد نقش", customerEditController.roleCode, ''),
                SizedBox(height: 10),
                myTextField(
                  "کد پستی",
                  customerEditController.postalCode,
                  customerInfoController.custmerinfolist[index].postalCode,
                  validator: (v) {
                    if (v == null || v.isEmpty) return null;
                    return _validator(_tenDigits, "کد پستی", v);
                  },
                  inputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
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

                  validator: (v) {
                    if (v == null || v.isEmpty) return null;
                    return _validator(_mobileReg, "شماره همراه", v);
                  },
                  inputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                ),
                SizedBox(height: 10),
                myTextField(
                  "شماره همراه 2",
                  customerEditController.mobileNumber2,
                  '',
                  validator: (v) {
                    if (v == null || v.isEmpty) return null;
                    return _validator(_mobileReg, "شماره همراه", v);
                  },
                  inputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                ),
                SizedBox(height: 10),
                myTextField(
                  "شماره ثابت",
                  customerEditController.phoneNumber,
                  customerInfoController.custmerinfolist[index].phone,
                  validator: (v) {
                    if (v == null || v.isEmpty) return null;
                    return _validator(_phoneReg, "شماره ثابت", v);
                  },
                  inputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                ),
                SizedBox(height: 10),
                myTextField(
                  "متراژ مغازه",
                  customerEditController.storeArea,
                  '',
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // همه فیلدها معتبرند؛ عملیات ذخیره را انجام بدهید
                    }
                  },
                  style: MyDecorations.mainButtom,
                  child: Text("ذخیره تغییرات", style: MyTextStyle.bottomstyle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myTextField(
    String labelText,
    TextEditingController controller,
    String title, {
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatter, // به احتمال زیاد نیاز نباشه
  }) {
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
        TextFormField(
          controller: controller,
          inputFormatters: inputFormatter,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
