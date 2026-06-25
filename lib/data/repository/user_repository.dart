import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/constans/storage_const.dart';
import 'package:ocean_sys/data/api_constant.dart';
import 'package:ocean_sys/data/services/dio_service.dart';
import 'package:ocean_sys/model/UserModel/user_model.dart';

class UserRepository {
  final DioService _dioService = DioService();
  final GetStorage _storage = GetStorage();

  Future<UserModel?> getUserData() async {
    try {
      final token = _storage.read(StorageKey.token);
      if (token == null) {
        print("Token not found");
        return null;
      }
      final options = Options(
        headers: {'Authorization': 'Bearer $token'},
        responseType: ResponseType.json,
        method: 'GET',
      );
      final response = await _dioService.getMetode(
        ApiUrlConstant.userdata,
        options: options,
      );
      if (response.statusCode == 200) {
        return UserModel.fromjeson(response.data);
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      Get.snackbar('خطا', 'خطا در برقراری ارتباط با سرور: $e');
      return null;
    }
  }
}
