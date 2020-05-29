class User {
  String id;
  String fullName;
  String email;
  String accountType;
  String token;
  bool staff;
  bool admin;
  bool isVerified;

  User(
      {this.id,
      this.fullName,
      this.email,
      this.accountType,
      this.token,
      this.staff,
      this.admin,
      this.isVerified});

  User.fromDatabaseJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    fullName = json['full_name'];
    email = json['email'];
    accountType = json['account_type'];
    token = json['token'];
    staff = json['staff'] == 0 ? false : true;
    admin = json['admin'] == 0 ? false : true;
    isVerified = json['is_verified'] == 0 ? false : true;
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
      };
}
