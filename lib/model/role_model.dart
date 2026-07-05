class RoleModel {
  int? id;
  String? name;
  String? description;

  RoleModel({this.id, this.name, this.description});

  RoleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }
}
