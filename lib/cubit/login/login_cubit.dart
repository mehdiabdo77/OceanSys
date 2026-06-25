import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/data/api_constant.dart';
import 'package:ocean_sys/constans/storage_const.dart';
import 'package:ocean_sys/cubit/login/login_state.dart';
import 'package:ocean_sys/data/services/dio_service.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController serverAddressController = TextEditingController();
  final storage = GetStorage();

  void init() {
    usernameController.text = storage.read(StorageKey.username) ?? '';
    passwordController.text = storage.read(StorageKey.password) ?? '';
    serverAddressController.text = storage.read(StorageKey.serverAddress) ?? '';
  }

  Future<void> login() async {
    // If controllers are empty, try to read from storage
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      final savedUsername = storage.read(StorageKey.username);
      final savedPassword = storage.read(StorageKey.password);

      if (savedUsername == null || savedPassword == null) {
        emit(LoginError('لطفا نام کاربری و رمز عبور را وارد کنید'));
        return;
      }

      // Use saved values
      usernameController.text = savedUsername;
      passwordController.text = savedPassword;
    }

    emit(LoginLoading());

    try {
      Map<String, dynamic> map = {
        'username': usernameController.text,
        'password': passwordController.text,
      };

      var response = await DioService().postMetode(map, ApiUrlConstant.login);
      print(response);

      if (response.statusCode == 200) {
        String token = response.data["access_token"];
        storage.write(StorageKey.token, token);
        storage.write(StorageKey.username, usernameController.text);
        storage.write(StorageKey.password, passwordController.text);
        emit(LoginSuccess());
      } else {
        emit(LoginError(response.statusMessage ?? 'خطای ناشناخته'));
      }
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  void saveServerAddress() {
    String server = serverAddressController.text;
    if (server.isEmpty) {
      emit(LoginError('لطفا ادرس سرور وارد کنید'));
      return;
    }
    storage.write(StorageKey.serverAddress, server);
  }

  @override
  Future<void> close() {
    usernameController.dispose();
    passwordController.dispose();
    serverAddressController.dispose();
    return super.close();
  }
}
