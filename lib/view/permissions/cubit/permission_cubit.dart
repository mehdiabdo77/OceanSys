import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/data/repository/permission_repository.dart';
import 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  final PermissionRepository repository = PermissionRepository();

  PermissionCubit() : super(PermissionInitial());

  Future<void> loadData() async {
    emit(PermissionLoading());
    try {
      final users = await repository.getAllUsers();
      final roles = await repository.getAllRolesPermissions();
      final permissions = await repository.getPermissions();

      if (users != null && roles != null && permissions != null) {
        emit(
          PermissionLoaded(
            users: users,
            roles: roles,
            permissions: permissions,
          ),
        );
      } else {
        emit(PermissionError("خطا در بارگذاری داده‌ها"));
      }
    } catch (e) {
      emit(PermissionError("خطا در بارگذاری داده‌ها: $e"));
    }
  }

  Future<void> updateUserPermissions({
    required int userId,
    required List<Map<String, dynamic>> permissions,
  }) async {
    emit(PermissionUpdating());
    try {
      final success = await repository.editUserPermissions(
        userId: userId,
        permissions: permissions,
      );
      if (success) {
        emit(PermissionUpdated());
        await loadData();
      } else {
        emit(PermissionError("خطا در ویرایش دسترسی‌ها"));
      }
    } catch (e) {
      emit(PermissionError("خطا در ویرایش دسترسی‌ها: $e"));
    }
  }

  Future<void> updateRolePermissions({
    required String roleName,
    required List<Map<String, dynamic>> permissions,
  }) async {
    emit(PermissionUpdating());
    try {
      final success = await repository.editRolePermissions(
        roleName: roleName,
        permissions: permissions,
      );
      if (success) {
        emit(PermissionUpdated());
        await loadData();
      } else {
        emit(PermissionError("خطا در ویرایش دسترسی‌های نقش"));
      }
    } catch (e) {
      emit(PermissionError("خطا در ویرایش دسترسی‌های نقش: $e"));
    }
  }

  Future<void> updateUserStatus({
    required String username,
    required bool isActive,
  }) async {
    emit(PermissionUpdating());
    try {
      final result = await repository.updateUserStatus(
        username: username,
        isActive: isActive,
      );
      if (result != null && result['success'] == true) {
        emit(UserStatusUpdated(result['message']));
        await loadData();
      } else {
        emit(PermissionError(result?['message'] ?? "خطا در تغییر وضعیت کاربر"));
      }
    } catch (e) {
      emit(PermissionError("خطا در تغییر وضعیت کاربر: $e"));
    }
  }

  Future<void> updateUserRole({
    required String username,
    required String roleName,
  }) async {
    emit(PermissionUpdating());
    try {
      final result = await repository.updateUserRole(
        username: username,
        roleName: roleName,
      );
      if (result != null && result['success'] == true) {
        emit(UserRoleUpdated(result['message']));
        await loadData();
      } else {
        emit(PermissionError(result?['message'] ?? "خطا در تغییر نقش کاربر"));
      }
    } catch (e) {
      emit(PermissionError("خطا در تغییر نقش کاربر: $e"));
    }
  }
}
