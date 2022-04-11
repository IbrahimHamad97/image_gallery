class UserModel {
  final String? uid;

  UserModel({this.uid});
}

class UserData{
  final String? uid;
  final String? userName;
  final String? email;
  final String? profilePic;
  final String? role;

  UserData({this.uid, this.userName, this.email, this.profilePic, this.role});
}