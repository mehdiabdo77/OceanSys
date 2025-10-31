import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ocean_sys/servies/customer_service.dart';

class CustomerEditController extends GetxController {
  // اطلاعات فرم اصلاحیه
  TextEditingController nationalCode = TextEditingController();
  TextEditingController roleCode = TextEditingController();
  TextEditingController postalCode = TextEditingController();
  TextEditingController customername = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController customerboard = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController mobileNumber2 = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController storeArea = TextEditingController();

  // مشتری غیر فعال سازی و شکایت
  TextEditingController crmCustomerDescription = TextEditingController();
  TextEditingController disActiveDescription = TextEditingController();

  // موارد انتخاب شده توسط کاربر
  var isCustomerVisit = false.obs; // آیا مشتری خودش سرکشی می‌کند؟
  var isOwnerInShop = false.obs; // آیا صاحب مغازه در مغازه هست؟
  var isCooperation = false.obs; // آیا مشتری همکاری میکند؟

  var selectedDisActive = "".obs;

  RxList<String> selectedProducts = <String>[].obs;
  final CustomerService _service = CustomerService();

  /// ارسال دلیل غیر فعال سازی مشتری
  Future<int?> sendDisActiveDescription(var customerCode) async {
    await _service.sendDisActiveDescription(
      customerCode,
      selectedDisActive.value,
      disActiveDescription.text,
    );
    return null;
  }

  Future<int?> taskComplete(var customerCode) async {
    _service.taskComplete(customerCode);
    return null;
  }

  // شکایت مشتری
  Future<int?> sendCRMCustomerDescription(var customerCode) async {
    _service.sendCRMCustomerDescription(
      customerCode,
      crmCustomerDescription.text,
      isCustomerVisit.value,
      isOwnerInShop.value,
      isCooperation.value,
    );
    return null;
  }

  // علاقه مندی های مشتری
  Future<int?> sendProductCategoryCustomer(var customerCode) async {
    _service.sendProductCategoryCustomer(customerCode, selectedProducts);
    return null;
  }

  // ادیت مشتری
  Future<int?> sendIditCustomer(var customerCode) async {
    _service.sendEditCustomer(
      customerCode: customerCode,
      nationalCode: nationalCode.text,
      roleCode: int.tryParse(roleCode.text),
      postalCode: postalCode.text,
      customerBoard: customerboard.text,
      customerName: customername.text,
      address: address.text,
      mobileNumber: mobileNumber.text,
      mobileNumber2: mobileNumber2.text,
      phoneNumber: phoneNumber.text,
      storeArea: int.parse(storeArea.text),
    );
    return null;
  }
}
