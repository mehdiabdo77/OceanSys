import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/constans/storage_const.dart';
import 'package:ocean_sys/data/api_constant.dart';
import 'package:ocean_sys/data/services/dio_service.dart';
import 'package:ocean_sys/model/RouteScannerModel/customer_info_model.dart';

class CustomerInfoRepository {
  final DioService _dioService = DioService();
  final GetStorage _storage = GetStorage();

  Future<List<CustomerInfoModel>> getCustomerInfo() async {
    try {
      final token = _storage.read(StorageKey.token);
      if (token == null) {
        print("Token not found");
        return [];
      }
      final options = Options(
        headers: {'Authorization': 'Bearer $token'},
        responseType: ResponseType.json,
      );
      final response = await _dioService.getMetode(
        ApiUrlConstant.coustmoerinfo,
        options: options,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => CustomerInfoModel.fromJson(e)).toList();
      } else {
        Get.snackbar('خطا', 'خطا در دریافت اطلاعات');
        return [];
      }
    } catch (e) {
      Get.snackbar('خطا', 'خطا در برقراری ارتباط با سرور');
      return [];
    }
  }
}
