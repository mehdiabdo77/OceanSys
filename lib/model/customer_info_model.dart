import 'dart:ffi';

class CustomerInfoModel {
  dynamic customerCode; // int
  dynamic customerName; // str
  dynamic customerBoard; // str
  dynamic nationalCode; // str
  dynamic area; // str - محدوده
  dynamic zone; // str - ناحیه
  dynamic route; // str - مسیر
  dynamic latitude; // float
  dynamic longitude; // float
  dynamic status; // str
  dynamic address; // str
  dynamic phone; // str
  dynamic mobile; // str | None
  dynamic postalCode; // str | None
  dynamic username; // str
  dynamic datavisit; // str
  int? visited; // int
  dynamic edit; // int

  CustomerInfoModel();

  CustomerInfoModel.fromJson(Map<String, dynamic> element) {
    customerCode = element["customer_code"];
    customerName = element["customer_name"];
    customerBoard = element["customer_board"];
    nationalCode = element["national_code"];
    area = element["area"];
    zone = element["zone"];
    route = element["route"];
    latitude = element["latitude"];
    longitude = element["longitude"];
    status = element["status"];
    address = element["address"];
    phone = element["phone"];
    mobile = element["mobile"];
    postalCode = element["postal_code"];
    username = element["username"];
    datavisit = element["datavisit"];
    visited = element["visited"];
    edit = element["edit"];
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_code': customerCode,
      'customer_name': customerName,
      'customer_board': customerBoard,
      'national_code': nationalCode,
      'area': area,
      'zone': zone,
      'route': route,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'address': address,
      'phone': phone,
      'mobile': mobile,
      'postal_code': postalCode,
      'username': username,
      'datavisit': datavisit,
      'visited': visited,
      'edit': edit,
    };
  }
}
