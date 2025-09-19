import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/constans/api_constant.dart';
import 'package:ocean_sys/constans/storage_const.dart';
import 'package:ocean_sys/database/local_db.dart';
import 'package:ocean_sys/model/customer_edit_model.dart';
import 'package:ocean_sys/model/disactive_customer_request.dart';
import 'package:ocean_sys/model/product_category_customer.dart';
import 'package:ocean_sys/model/task_complete.dart';
import 'package:ocean_sys/servies/dio_service.dart';
import 'package:ocean_sys/servies/dio_service.dart' as dio;
import '../model/CRM_customer_description.dart';

// TODO بعد که دیباگ کردن تموم شد تمام پرینت هارو پاک کن برای خلوت کردن کد ها
// TODO برای خلوتی کد ها کد های ذخیره افلاین و کار های تکررای بین کنترلر ها در یک فایل جداگانه درستش کن
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
      cooperation: isCooperation.value,
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
    print('[CustomerEditController] Sending request to $url');

    try {
      final response = await DioService().postJson(
        map,
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return _handleResponse(response, url, map);
    } catch (e) {
      print('[CustomerEditController] Exception: $e');
      // ذخیره افلاین
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
    print(
      '[CustomerEditController] Saving request for offline sending: $errorMessage',
    );
    await LocalDb.insertRequest(url, jsonEncode(map));
    Get.snackbar("ذخیره شد", "اطلاعات ذخیره شد و بعدا ارسال خواهد شد");
  }

  Future<void> sendOfflineRequest() async {
    print('[CustomerEditController] sendOfflineRequest called');
    final token = storage.read(StorageKey.token);

    if (token == null || token.isEmpty) {
      print('[CustomerEditController] No token available for offline requests');
      Get.snackbar(
        "خطا",
        "توکن معتبر برای ارسال درخواست‌های آفلاین وجود ندارد",
      );
      return;
    }

    final requests = await LocalDb.getPendingRequests();
    print('[CustomerEditController] Found ${requests.length} pending requests');

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
      print(
        '[CustomerEditController] Processing offline request: url=$url, id=$id',
      );

      try {
        final response = await DioService().postJson(
          payload,
          url,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        print(
          '[CustomerEditController] Response: statusCode=${response?.statusCode}',
        );

        if (response?.statusCode == 200) {
          await LocalDb.deletePendingRequest(id);
          print(
            '[CustomerEditController] Successfully sent and deleted request id=$id',
          );
          successCount++;
        } else {
          print(
            '[CustomerEditController] Failed to send request id=$id: ${response?.statusMessage}',
          );
          failCount++;
        }
      } catch (e) {
        print('[CustomerEditController] Error sending offline request: $e');
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
