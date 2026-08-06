import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/data/api_constant.dart';
import 'package:ocean_sys/constans/storage_const.dart';
import 'package:ocean_sys/data/services/dio_service.dart';
import 'package:ocean_sys/model/route_model.dart';

class RouteRepository {
  final DioService _dioService = DioService();
  final GetStorage _storage = GetStorage();

  Future<bool> setRoute(RouteModel routeModel) async {
    try {
      final token = _storage.read(StorageKey.token);
      if (token == null) {
        Get.snackbar("خطا", "توکن احراز هویت یافت نشد");
        return false;
      }

      final options = Options(
        headers: {'Authorization': 'Bearer $token'},
        responseType: ResponseType.json,
        method: 'POST',
      );

      final response = await _dioService.postJson(
        routeModel.toJson(),
        ApiUrlConstant.setRoute,
        options: options,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("موفقیت", "مسیر با موفقیت ثبت شد");
        return true;
      } else {
        String message = response.statusMessage ?? "خطا در ثبت مسیر";
        if (response.data != null && response.data['detail'] != null) {
          message = response.data['detail'].toString();
        }
        Get.snackbar("خطا", message);
        return false;
      }
    } catch (e) {
      Get.snackbar("خطا", "خطا در ارتباط با سرور: $e");
      return false;
    }
  }

  Future<bool> deleteRoute(RouteModel routeModel) async {
    try {
      final token = _storage.read(StorageKey.token);
      if (token == null) {
        Get.snackbar("خطا", "توکن احراز هویت یافت نشد");
        return false;
      }

      final options = Options(
        headers: {'Authorization': 'Bearer $token'},
        responseType: ResponseType.json,
        method: 'DELETE',
      );

      // Using dio directly for DELETE with data body
      final response = await _dioService.dio.delete(
        ApiUrlConstant.deleteRoute,
        data: routeModel.toJson(),
        options: options,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.snackbar("موفقیت", "مسیر با موفقیت حذف شد");
        return true;
      } else {
        String message = response.statusMessage ?? "خطا در حذف مسیر";
        if (response.data != null && response.data['detail'] != null) {
          message = response.data['detail'].toString();
        }
        Get.snackbar("خطا", message);
        return false;
      }
    } catch (e) {
      if (e is DioError && e.response != null) {
        String message = e.response?.statusMessage ?? "خطا در حذف مسیر";
        if (e.response?.data != null && e.response?.data['detail'] != null) {
          message = e.response!.data['detail'].toString();
        }
        Get.snackbar("خطا", message);
      } else {
        Get.snackbar("خطا", "خطا در ارتباط با سرور: $e");
      }
      return false;
    }
  }
}
