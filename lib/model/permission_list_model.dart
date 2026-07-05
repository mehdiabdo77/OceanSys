class PermissionListModel {
  int? id;
  String? code;
  String? name;
  String? description;

  PermissionListModel({this.id, this.code, this.name, this.description});

  PermissionListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    description = json['description'];
  }
}
