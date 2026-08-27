import 'package:ocean_sys/model/UserModel/Permission_model.dart';

class RoleModel {
  int? id;
  int? roleId;
  String? name;
  String? roleName;
  String? description;
  PermissionModel? permission;
  List<PermissionItemModel>? permissions;

  RoleModel({
    this.id,
    this.roleId,
    this.name,
    this.roleName,
    this.description,
    this.permission,
    this.permissions,
  });

  int get roleIdValue => id ?? roleId ?? 0;
  String get roleNameValue => name ?? roleName ?? '';

  RoleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['role_id'];
    name = json['name'];
    roleName = json['role_name'];
    description = json['description'];
    if (json['permission'] != null) {
      permission = PermissionModel.fromJson(json['permission']);
    }
    if (json['permissions'] != null && json['permissions'] is List) {
      permissions = [];
      for (var v in json['permissions']) {
        permissions!.add(PermissionItemModel.fromJson(v));
      }
      if (permission == null) {
        permission = PermissionModel(
          status: true,
          data: permissions,
        );
      }
    }
  }
}
