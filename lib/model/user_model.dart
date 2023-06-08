class UserModel {
  late String id;
  late String email;
  late String image;
  late String mobile;
  late bool partner;
  late String userName;
  UserModel(
      {required this.id,
      required this.email,
      required this.image,
      required this.mobile,
      this.partner = false,
      required this.userName});
  UserModel.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    email = map['email'];
    image = map['image'];
    mobile = map['mobile'];
    userName = map['username'];
  }
  toJson() {
    return {
      'id': id,
      'email': email,
      'image': image,
      'mobile': mobile,
      'partner': partner,
      'username': userName
    };
  }
}
