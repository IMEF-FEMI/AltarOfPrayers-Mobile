import 'package:meta/meta.dart';

class User {
  String id;
  String fullName;
  String email;
  String accountType;
  String token;
  bool staff;
  bool admin;
  bool isVerified;
  String createdAt;

  User(
      {@required this.id,
      @required this.fullName,
      @required this.email,
      @required this.accountType,
      @required this.token,
      @required this.staff,
      @required this.admin,
      @required this.isVerified,
      @required this.createdAt});

  User.fromDatabaseJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    fullName = json['full_name'];
    email = json['email'];
    accountType = json['account_type'];
    token = json['token'];
    staff = json['staff'] == 0 ? false : true;
    admin = json['admin'] == 0 ? false : true;
    isVerified = json['is_verified'] == 0 ? false : true;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "full_name": this.fullName,
        "email": this.email,
        "account_type": this.accountType,
        "token": this.token,
        "staff": this.staff == false ? 0 : 1,
        "admin": this.admin == false ? 0 : 1,
        "is_verified": this.isVerified == false ? 0 : 1,
        "created_at": this.createdAt
      };
}
