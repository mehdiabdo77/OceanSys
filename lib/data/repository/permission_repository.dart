import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/constans/storage_const.dart';
import 'package:ocean_sys/data/api_constant.dart';
import 'package:ocean_sys/data/repository/user_repository.dart';
import 'package:ocean_sys/data/services/dio_service.dart';
import 'package:ocean_sys/model/UserModel/user_model.dart';
import 'package:ocean_sys/model/permission_list_model.dart';
import 'package:ocean_sys/model/role_model.dart';

class PermissionRepository {
  final DioService _dioService = DioService();
  final GetStorage _storage = GetStorage();
  final UserRepository _userRepository = UserRepository();

  Future<List<UserModel>?> getAllUsers() async {
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
        ApiUrlConstant.getAllUserdata,
        options: options,
      );
      if (response.statusCode == 200) {
        List<UserModel> users = [];
        for (var item in response.data) {
          users.add(UserModel.fromjeson(item));
        }
        return users;
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      Get.snackbar('خطا', 'خطا در برقراری ارتباط با سرور: $e');
      return null;
    }
  }

  Future<List<RoleModel>?> getRoles() async {
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
        ApiUrlConstant.getRoleList,
        options: options,
      );
      if (response.statusCode == 200) {
        List<RoleModel> roles = [];
        for (var item in response.data) {
          roles.add(RoleModel.fromJson(item));
        }
        return roles;
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      Get.snackbar('خطا', 'خطا در برقراری ارتباط با سرور: $e');
      return null;
    }
  }

  Future<List<PermissionListModel>?> getPermissions() async {
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
        ApiUrlConstant.getPermissionList,
        options: options,
      );
      if (response.statusCode == 200) {
        List<PermissionListModel> permissions = [];
        for (var item in response.data) {
          permissions.add(PermissionListModel.fromJson(item));
        }
        return permissions;
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      Get.snackbar('خطا', 'خطا در برقراری ارتباط با سرور: $e');
      return null;
    }
  }

  Future<bool> editUserPermissions({
    required int userId,
    required List<Map<String, dynamic>> permissions,
  }) async {
    try {
      final token = _storage.read(StorageKey.token);
      if (token == null) {
        print("Token not found");
        return false;
      }
      final options = Options(
        headers: {'Authorization': 'Bearer $token'},
        responseType: ResponseType.json,
        method: 'PUT',
      );
      final data = [
        {"permissions": permissions, "identifier": userId},
      ];
      print(
        "Sending editUserPermissions request to: ${ApiUrlConstant.editPermissionUser}",
      );
      print("Request data: $data");
      final response = await _dioService.putJson(
        data,
        ApiUrlConstant.editPermissionUser,
        options: options,
      );
      print("Response status code: ${response.statusCode}");
      print("Response data: ${response.data}");
      if (response.statusCode == 200) {
        Get.snackbar('موفق', 'دسترسی‌ها با موفقیت ویرایش شد');
        return true;
      } else {
        Get.snackbar(
          'خطا',
          'خطا در ویرایش دسترسی‌ها (کد: ${response.statusCode})',
        );
        return false;
      }
    } catch (e) {
      print("Error in editUserPermissions: $e");
      Get.snackbar('خطا', 'خطا در برقراری ارتباط با سرور: $e');
      return false;
    }
  }

  Future<bool> editRolePermissions({
    required String roleName,
    required List<Map<String, dynamic>> permissions,
  }) async {
    try {
      final token = _storage.read(StorageKey.token);
      if (token == null) {
        print("Token not found");
        return false;
      }
      final options = Options(
        headers: {'Authorization': 'Bearer $token'},
        responseType: ResponseType.json,
        method: 'PUT',
      );
      final data = [
        {"permissions": permissions, "identifier": roleName},
      ];
      print(
        "Sending editRolePermissions request to: ${ApiUrlConstant.editPermissionRole}",
      );
      print("Request data: $data");
      final response = await _dioService.putJson(
        data,
        ApiUrlConstant.editPermissionRole,
        options: options,
      );
      print("Response status code: ${response.statusCode}");
      print("Response data: ${response.data}");
      if (response.statusCode == 200) {
        Get.snackbar('موفق', 'دسترسی‌های نقش با موفقیت ویرایش شد');
        return true;
      } else {
        Get.snackbar(
          'خطا',
          'خطا در ویرایش دسترسی‌های نقش (کد: ${response.statusCode})',
        );
        return false;
      }
    } catch (e) {
      print("Error in editRolePermissions: $e");
      Get.snackbar('خطا', 'خطا در برقراری ارتباط با سرور: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> updateUserStatus({
    required String username,
    required bool isActive,
  }) async {
    return await _userRepository.updateUserStatus(
      username: username,
      isActive: isActive,
    );
  }
}
