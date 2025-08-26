import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/constans/api_constant.dart';
import 'package:ocean_sys/constans/storage_const.dart';
import 'package:ocean_sys/model/customer_edit_model.dart';
import 'package:ocean_sys/model/disactive_customer_request.dart';
import 'package:ocean_sys/model/point_model.dart';
import 'package:ocean_sys/model/product_category_customer.dart';
import 'package:ocean_sys/model/task_complete.dart';
import 'package:ocean_sys/servies/dio_service.dart';

import '../model/CRM_customer_description.dart';

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
  var selectedDisActive = "".obs;

  RxList<String> selectedProducts = <String>[].obs;

  final storage = GetStorage();

  /// ارسال دلیل غیر فعال سازی مشتری
  Future<int?> sendDisActiveDescription(var customerCode) async {
    final payload = DisactiveCustomerRequest(
      customerCode: customerCode.toString(),
      reason: selectedDisActive.value,
      description: disActiveDescription.text,
    );

    return _postWithAuth(ApiUrlConstant.disactiveCode, payload.toJson());
  }

  Future<int?> taskComplete(var customerCode) async {
    final payload = TaskComplete(customerCode: customerCode.toString());

    return _postWithAuth(ApiUrlConstant.taskComplete, payload.toJson());
  }

  // شکایت مشتری
  Future<int?> sendCRMCustomerDescription(var customerCode) async {
    final payload = CRMCustomerDescriptionRequest(
      customerCode: customerCode.toString(),
      description: crmCustomerDescription.text,
      customerVisit: isCustomerVisit.value,
      ownerInShop: isOwnerInShop.value,
    );

    return _postWithAuth(
      ApiUrlConstant.crmCustomerDescription,
      payload.toJson(),
    );
  }

  // علاقه مندی های مشتری
  Future<int?> sendProductCategoryCustomer(var customerCode) async {
    final payload = ProductCategoryCustomer(
      customerCode: customerCode.toString(),
      sku: selectedProducts,
    );

    return _postWithAuth(ApiUrlConstant.productCategory, payload.toJson());
  }

  // ادیت مشتری
  Future<int?> sendIditCustomer(var customerCode) async {
    final payload = CustomerEditModel(
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
      storeArea: int.tryParse(storeArea.text) ?? 0,
    );

    return _postWithAuth(ApiUrlConstant.editCoustomerInfo, payload.toJson());
  }

  /// هلسپر مشترک برای ارسال درخواست JSON با هدر Authorization
  Future<int?> _postWithAuth(String url, Map<String, dynamic> map) async {
    final token = storage.read(StorageKey.token);
    print(map);
    try {
      final response = await DioService()
          .postJson(
            map,
            url,
            options: Options(headers: {'Authorization': 'Bearer $token'}),
          )
          .catchError((error) {
            print(error);
          });
      print(response.statusCode);
      if (response.statusCode == 200) {
        Get.snackbar("موفقیت", "اطلاعات با موفقیت ارسال شد");
      } else if (response.statusCode == 400) {
        Get.snackbar("خطا", "مشتری قبلا غیر فعال شده است");
      } else {
        Get.snackbar(
          "خطا",
          "${response.statusMessage}",
          borderColor: Colors.red,
          borderWidth: 3,
        );
      }
    } catch (e) {
      Get.snackbar("خطا", "${e.toString()}");
      return null; // خطای شبکه یا استثناء دیگر
    }
  }
}
