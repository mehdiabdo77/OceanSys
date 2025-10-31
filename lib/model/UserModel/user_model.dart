import 'package:ocean_sys/model/UserModel/Permission_model.dart';

class UserModel {
  String? user;
  String? firstName;
  String? lastName;
  bool? isActive;
  PermissionModel? permission;

  UserModel();

  UserModel.fromjeson(Map<String, dynamic> element) {
    user = element['user'];
    firstName = element['first_name'];
    lastName = element['last_name'];
    isActive = element['is_active'];
    permission = element['permission'] != null
        ? PermissionModel.fromJson(element['permission'])
        : null;
  }
}
