import 'package:ocean_sys/model/UserModel/Permission_model.dart';

class RoleModel {
  int? id;
  String? name;
  String? description;
  PermissionModel? permission;

  RoleModel({this.id, this.name, this.description, this.permission});

  RoleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    permission = json['permission'] != null
        ? PermissionModel.fromJson(json['permission'])
        : null;
  }
}
