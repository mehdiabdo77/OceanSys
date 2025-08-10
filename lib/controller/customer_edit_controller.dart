import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/constans/api_constant.dart';
import 'package:ocean_sys/constans/storage_const.dart';
import 'package:ocean_sys/servies/dio_service.dart';

class CustomerEditController extends GetxController {
  TextEditingController disActiveDescription = TextEditingController();
  TextEditingController nationalCode = TextEditingController();
  TextEditingController roleCode = TextEditingController();
  TextEditingController postalCode = TextEditingController();
  TextEditingController ownerName = TextEditingController();
  TextEditingController storeName = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController mobileNumber2 = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController storeArea = TextEditingController();

  var selected = "".obs;
  final storage = GetStorage();

  /// ارسال دلیل غیر فعال سازی مشتری
  Future<int?> sendDisActiveDescription(var customerCode) async {
    Map<String, dynamic> map = {
      "customer_code": customerCode.toString(),
      "Reason": selected.value,
      "Description": disActiveDescription.text,
    };

    final token = storage.read(StorageKey.token);
    try {
      final response = await DioService().postJson(
        map,
        ApiUrlConstant.disactiveCode,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.statusCode as int?; // 200، 400 یا …
    } catch (e) {
      return null; // خطای شبکه یا استثناء دیگر
    }
  }
}
