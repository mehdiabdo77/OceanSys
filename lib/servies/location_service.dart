import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/constans/api_constant.dart';
import 'package:ocean_sys/constans/storage_const.dart';
import 'package:ocean_sys/model/point_model.dart';
import 'package:ocean_sys/servies/dio_service.dart';

class LocationService {
  final storage = GetStorage();

  Future<void> sendUserLocation(LatAndlongModel payload) async {
    final token = storage.read(StorageKey.token);
    try {
      final response = await DioService().postJson(
        payload.toJson(),
        ApiUrlConstant.latAndLong,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        Get.snackbar("موفقیت", "اطلاعات با موفقیت ارسال شد");
      } else {
        Get.snackbar(
          "خطا",
          "${response.statusMessage}",
          borderColor: Colors.red,
          borderWidth: 3,
        );
      }
    } catch (e) {
      Get.snackbar("خطا", e.toString());
      return null;
    }
  }
}
