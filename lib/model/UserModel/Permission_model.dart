class PermissionItemModel {
  String? name;
  int? hasAccess;

  PermissionItemModel({this.name, this.hasAccess});

  PermissionItemModel.fromJson(Map<String, dynamic> json) {
    name = json['code'];
    hasAccess = json['has_access'];
  }
}

class PermissionModel {
  bool? status;
  List<PermissionItemModel>? data;

  PermissionModel({this.status, this.data});

  PermissionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(PermissionItemModel.fromJson(v));
      });
    }
  }
}

// TODO بعدا بررسی کن که ایا منطقیه این دو تا رو تو یک فایل جداگانه در نظر بگیرم
