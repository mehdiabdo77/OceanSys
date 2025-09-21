import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/constans/api_constant.dart';
import 'package:ocean_sys/constans/storage_const.dart';
import 'package:ocean_sys/database/local_db.dart';
import 'package:ocean_sys/model/CRM_customer_description.dart';
import 'package:ocean_sys/model/customer_edit_model.dart';
import 'package:ocean_sys/model/disactive_customer_request.dart';
import 'package:ocean_sys/model/product_category_customer.dart';
import 'package:ocean_sys/model/task_complete.dart';
import 'package:ocean_sys/servies/dio_service.dart';

class CustomerService {
  final storage = GetStorage();

  Future<int?> sendDisActiveDescription(
    dynamic customerCode,
    String reason,
    String description,
  ) async {
    final payload = DisactiveCustomerRequest(
      customerCode: customerCode.toString(),
      reason: reason,
      description: description,
    );
    return _postWithAuth(ApiUrlConstant.disactiveCode, payload.toJson());
  }

  Future<int?> taskComplete(var customerCode) async {
    final payload = TaskComplete(customerCode: customerCode.toString());

    return _postWithAuth(ApiUrlConstant.taskComplete, payload.toJson());
  }

  // شکایت مشتری
  Future<int?> sendCRMCustomerDescription(
    var customerCode,
    String description,
    bool customerVisit,
    bool ownerInShop,
    bool cooperation,
  ) async {
    final payload = CRMCustomerDescriptionRequest(
      customerCode: customerCode.toString(),
      description: description,
      customerVisit: customerVisit,
      ownerInShop: ownerInShop,
      cooperation: cooperation,
    );

    return _postWithAuth(
      ApiUrlConstant.crmCustomerDescription,
      payload.toJson(),
    );
  }

  // علاقه مندی های مشتری
  Future<int?> sendProductCategoryCustomer(
    var customerCode,
    List<String> selectedProducts,
  ) async {
    final payload = ProductCategoryCustomer(
      customerCode: customerCode.toString(),
      sku: selectedProducts,
    );

    return _postWithAuth(ApiUrlConstant.productCategory, payload.toJson());
  }

  // ادیت مشتری
  Future<int?> sendEditCustomer({
    required dynamic customerCode,
    required String nationalCode,
    required int? roleCode,
    required String postalCode,
    required String customerBoard,
    required String customerName,
    required String address,
    required String mobileNumber,
    required String mobileNumber2,
    required String phoneNumber,
    required int? storeArea,
  }) async {
    final payload = CustomerEditModel(
      customerCode: customerCode,
      nationalCode: nationalCode,
      roleCode: roleCode,
      postalCode: postalCode,
      customerBoard: customerBoard,
      customerName: customerName,
      address: address,
      mobileNumber: mobileNumber,
      mobileNumber2: mobileNumber2,
      phoneNumber: phoneNumber,
      storeArea: storeArea,
    );
    return _postWithAuth(ApiUrlConstant.editCoustomerInfo, payload.toJson());
  }

  // متد مشترک برای ارسال اطلاعات
  Future<int?> _postWithAuth(String url, Map<String, dynamic> map) async {
    final token = storage.read(StorageKey.token);
    print('[CustomerService] Sending request to $url');

    try {
      final response = await DioService().postJson(
        map,
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return _handleResponse(response, url, map);
    } catch (e) {
      print('[CustomerService] Exception: $e');
      await _saveForOfflineSending(url, map, e.toString());
      return null;
    }
  }

  // Centralized response handling
  Future<int?> _handleResponse(
    var response,
    String url,
    Map<String, dynamic> map,
  ) async {
    // Handle null response
    if (response == null) {
      print('[CustomerEditController] DioService returned null response');
      Get.snackbar("خطا", "پاسخ سرور دریافت نشد (null)");
      await _saveForOfflineSending(url, map, "Null response");
      return null;
    }

    // Handle response based on status code
    switch (response.statusCode) {
      case 200:
        Get.snackbar("موفقیت", "اطلاعات با موفقیت ارسال شد");
        return response.statusCode;

      case 400:
        Get.snackbar("خطا", "مشتری قبلا غیر فعال شده است");
        return response.statusCode;

      case 0:
      case 1:
      case -1:
        Get.snackbar("خطا", "اینترنت یا سرور قطع است بعد اطلاعات ذخیره میشود");
        await _saveForOfflineSending(
          url,
          map,
          "Network error: ${response.statusCode}",
        );
        return response.statusCode;

      default:
        Get.snackbar(
          "خطا",
          "${response.statusMessage}",
          borderColor: Colors.red,
          borderWidth: 3,
        );
        return response.statusCode;
    }
  }

  // تابع برای هندل کردن ذخیره افلاین
  Future<void> _saveForOfflineSending(
    String url,
    Map<String, dynamic> map,
    String errorMessage,
  ) async {
    await LocalDb.insertRequest(url, jsonEncode(map));
    Get.snackbar("ذخیره شد", "اطلاعات ذخیره شد و بعدا ارسال خواهد شد");
  }

  Future<void> sendOfflineRequest() async {
    final token = storage.read(StorageKey.token);

    if (token == null || token.isEmpty) {
      Get.snackbar(
        "خطا",
        "توکن معتبر برای ارسال درخواست‌های آفلاین وجود ندارد",
      );
      return;
    }

    final requests = await LocalDb.getPendingRequests();

    if (requests.isEmpty) {
      Get.snackbar("اطلاع", "درخواست آفلاینی برای ارسال وجود ندارد");
      return;
    }

    int successCount = 0;
    int failCount = 0;

    for (var req in requests) {
      final url = req['url'];
      final payload = jsonDecode(req['payload']);
      final id = req['id'];

      try {
        final response = await DioService().postJson(
          payload,
          url,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (response?.statusCode == 200) {
          await LocalDb.deletePendingRequest(id);

          successCount++;
        } else {
          failCount++;
        }
      } catch (e) {
        failCount++;
      }
    }

    // نمایش خلاصه به کاربر
    if (successCount > 0 && failCount == 0) {
      Get.snackbar("موفقیت", "$successCount درخواست با موفقیت ارسال شد");
    } else if (successCount > 0 && failCount > 0) {
      Get.snackbar(
        "ارسال ناقص",
        "$successCount درخواست ارسال شد، $failCount درخواست ناموفق بود",
        borderColor: Colors.orange,
        borderWidth: 2,
      );
    } else {
      Get.snackbar(
        "خطا",
        "ارسال درخواست‌های آفلاین ناموفق بود",
        borderColor: Colors.red,
        borderWidth: 3,
      );
    }
  }
}
