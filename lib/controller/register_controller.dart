import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/constans/api_constant.dart';
import 'package:ocean_sys/constans/storage_const.dart';
import 'package:ocean_sys/main.dart';
import 'package:ocean_sys/servies/dio_service.dart';
import 'package:ocean_sys/view/map_page.dart';

class RegisterController extends GetxController {
  TextEditingController usercontroler = TextEditingController();
  TextEditingController passwordcontroler = TextEditingController();
  TextEditingController serverAddressController = TextEditingController();
  final storage = GetStorage();

  var user = '';
  var password = '';

  @override
  void onInit() {
    super.onInit();
    usercontroler.text = storage.read(StorageKey.username) ?? '';
    passwordcontroler.text = storage.read(StorageKey.password) ?? '';
  }

  veryfy() async {
    user = usercontroler.text;
    password = passwordcontroler.text;

    if (user.isEmpty || password.isEmpty) {
      Get.snackbar("خطا", "لطفا نام کاربری و رمز عبور را وارد کنید");
      return false;
    }

    Map<String, dynamic> map = {'username': user, 'password': password};

    var response = await DioService()
        .postMetode(map, ApiUrlConstant.login)
        .then((response) {
          if (response.statusCode == 200) {
            return response.data["access_token"];
          } else {
            Get.snackbar("خطا", "یوزر پسورد استباه است لطفا مجدد امتحان کنید ");
          }
        });

    storage.write(StorageKey.token, response);
    if (response != null) {
      storage.write(StorageKey.username, user);
      storage.write(StorageKey.password, password);
    }

    if (storage.read(StorageKey.token) != null) {
      Get.toNamed(NamedRoute.homepage);
    }
  }
}
