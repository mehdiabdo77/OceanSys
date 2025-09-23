import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';

import 'package:ocean_sys/constans/api_constant.dart';
import 'package:ocean_sys/constans/storage_const.dart';
import 'package:ocean_sys/model/RouteScannerModel/customer_info_model.dart';
import 'package:ocean_sys/servies/dio_service.dart';

class CustomerInfoController extends GetxController {
  RxList<CustomerInfoModel> custmerinfolist = RxList();
  RxList<Map<String, dynamic>> customerPoints = RxList();

  final storage = GetStorage();
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getCustumerInfo();
  }

  getCustumerInfo() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = storage.read(StorageKey.token);

      if (token == null) {
        errorMessage.value = 'توکن یافت نشد. لطفا دوباره وارد شوید';
        return;
      }

      // ساخت هدر برای ارسال توکن
      final options = Options(
        headers: {'Authorization': 'Bearer $token'},
        responseType: ResponseType.json,
        method: 'GET',
      );

      var response = await DioService().getMetode(
        ApiUrlConstant.coustmoerinfo,
        options: options,
      );

      if (response.statusCode == 200) {
        debugPrint("API response received");
        custmerinfolist.clear();

        final List<dynamic> data = response.data;

        data.forEach((val) {
          custmerinfolist.add(CustomerInfoModel.fromJson(val));
        });

        debugPrint(" le ${custmerinfolist.length}");
        debugPrint(custmerinfolist.isEmpty.toString());
      } else {
        errorMessage.value = 'خطا در دریافت اطلاعات: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'خطا در ارتباط با سرور: $e';
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> getPoint() {
    for (var customer in custmerinfolist) {
      if (customer.latitude != null &&
          customer.longitude != null &&
          customer.address != null) {
        customerPoints.add({
          'name': customer.customerBoard,
          'isvusit': customer.visited,
          'location': LatLng(
            double.tryParse(customer.latitude.toString()) ?? 0.0,
            double.tryParse(customer.longitude.toString()) ?? 0.0,
          ),
        });
      }
    }
    debugPrint("$customerPoints");
    return customerPoints;
  }
}
