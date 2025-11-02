import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/constans/api_constant.dart';
import 'package:ocean_sys/constans/storage_const.dart';
import 'package:ocean_sys/model/UserModel/user_model.dart';
import 'package:ocean_sys/servies/dio_service.dart';

class UserController extends GetxController {
  final storage = GetStorage();
  RxBool isLoading = false.obs;
  RxList<UserModel> userList = RxList();
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  getUserData() async {
    try {
      isLoading.value = true;
      String token = storage.read(StorageKey.token);
      if (token == null) {
        isLoading.value = false;
        return;
      }

      final options = Options(
        headers: {'Authorization': 'Bearer $token'},
        responseType: ResponseType.json,
        method: 'GET',
      );

      var response = await DioService().getMetode(
        ApiUrlConstant.userdata,
        options: options,
      );

      if (response.statusCode == 200) {
        debugPrint("API response received user data");
        userList.clear();
        final dynamic data = response.data;
        userList.add(UserModel.fromjeson(data));
        debugPrint(" le ${userList.length}");
      } else {
        errorMessage.value = 'خطا در دریافت اطلاعات: ${response.statusCode}';
        debugPrint(errorMessage.value);
      }
      isLoading.value = false;
    } catch (e) {
      debugPrint("error $e");
    }
  }
}
