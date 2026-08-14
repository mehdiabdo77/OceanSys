import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/constans/storage_const.dart';

class ApiUrlConstant {
  final storage = GetStorage();
  ApiUrlConstant._();
  static String baseUrl =
      GetStorage().read(StorageKey.serverAddress) ?? "http://192.168.1.2:8282/";
  static String login = "${baseUrl}token";
  static String userdata = "${baseUrl}getUserdata";
  static String getAllUserdata = "${baseUrl}getAllUserdata";
  static String getRoleList = "${baseUrl}get_role_list";
  static String getPermissionList = "${baseUrl}get_permission_list";
  static String register = "${baseUrl}register";
  static String editPermissionUser = "${baseUrl}edit_permission_user";
  static String editPermissionRole = "${baseUrl}edit_permission_role";
  static String coustmoerinfo = "${baseUrl}getCustomerData";
  static String disactiveCode = "${baseUrl}disActiveCustomer";
  static String productCategory = "${baseUrl}ProductCategory";
  static String crmCustomerDescription = "${baseUrl}CRMCustomerDescription";
  static String editCoustomerInfo = "${baseUrl}editcoustomerinfo";
  static String latAndLong = "${baseUrl}point";
  static String taskComplete = "${baseUrl}task_complete";
  static String setRoute = "${baseUrl}set_rout";
  static String deleteRoute = "${baseUrl}del_rout";

  static String changeUserRole = "${baseUrl}change_user_role";

  static String updateUserStatus(String username) =>
      "${baseUrl}${username}/status";
}
