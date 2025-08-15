import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/constans/storage_const.dart';

class ApiUrlConstant {
  final storage = GetStorage();
  ApiUrlConstant._();
  static String baseUrl =
      GetStorage().read(StorageKey.serverAddress) ?? 'https://api.example.com/';
  static String login = "${baseUrl}token";
  static String coustmoerinfo = "${baseUrl}getCustomerData";
  static String disactiveCode = "${baseUrl}disActiveCustomer";
  static String productCategory = "${baseUrl}ProductCategory";
  static String crmCustomerDescription = "${baseUrl}CRMCustomerDescription";
  static String editCoustomerInfo = "${baseUrl}editcoustomerinfo";
  static String latAndLong = "${baseUrl}LatAndLong";
}
