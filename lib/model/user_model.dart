class UserModel {
  String? user;
  String? password;

  UserModel();

  UserModel.fromjeson(Map<String, dynamic> element) {
    user = element['user'];
    password = element['password'];
  }
}
