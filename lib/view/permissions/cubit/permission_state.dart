import 'package:ocean_sys/model/UserModel/user_model.dart';
import 'package:ocean_sys/model/permission_list_model.dart';
import 'package:ocean_sys/model/role_model.dart';

abstract class PermissionState {}

class PermissionInitial extends PermissionState {}

class PermissionLoading extends PermissionState {}

class PermissionLoaded extends PermissionState {
  final List<UserModel> users;
  final List<RoleModel> roles;
  final List<PermissionListModel> permissions;

  PermissionLoaded({
    required this.users,
    required this.roles,
    required this.permissions,
  });
}

class PermissionError extends PermissionState {
  final String message;

  PermissionError(this.message);
}

class PermissionUpdating extends PermissionState {}

class PermissionUpdated extends PermissionState {}

class UserStatusUpdated extends PermissionState {
  final String message;
  UserStatusUpdated(this.message);
}

class UserRoleUpdated extends PermissionState {
  final String message;
  UserRoleUpdated(this.message);
}
