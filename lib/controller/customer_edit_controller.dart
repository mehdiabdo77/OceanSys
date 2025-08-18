import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/constans/api_constant.dart';
import 'package:ocean_sys/constans/storage_const.dart';
import 'package:ocean_sys/model/customer_edit_model.dart';
import 'package:ocean_sys/model/disactive_customer_request.dart';
import 'package:ocean_sys/model/product_category_customer.dart';
import 'package:ocean_sys/servies/dio_service.dart';

import '../model/CRM_customer_description.dart';
import '../model/edti_lat&long.dart';

class CustomerEditController extends GetxController {
  TextEditingController disActiveDescription = TextEditingController();
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
  TextEditingController crmCustomerDescription = TextEditingController();

  var selectedDisActive = "".obs;
  // var crmCustomerDescription = "".obs;

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

  Future<int?> sendCRMCustomerDescription(var customerCode) async {
    final payload = CRMCustomerDescriptionRequest(
      customerCode: customerCode.toString(),
      description: crmCustomerDescription.text, // اصلاح استفاده از کنترلر درست
    );

    return _postWithAuth(
      ApiUrlConstant.crmCustomerDescription,
      payload.toJson(),
    );
  }

  Future<int?> sendProductCategoryCustomer(var customerCode) async {
    final payload = ProductCategoryCustomer(
      customerCode: customerCode.toString(),
      sku: selectedProducts,
    );

    return _postWithAuth(ApiUrlConstant.productCategory, payload.toJson());
  }


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
      final response = await DioService().postJson(
        map,
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.statusCode as int?; // 200، 400، ...
    } catch (e) {
      return null; // خطای شبکه یا استثناء دیگر
    }
  }
}
