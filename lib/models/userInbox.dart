class UserInbox {
  final String uid;
  final int lastLogin;
  final int createdAt;
  final int buildNumber;
  final int age;
  String userName;
  bool showAge;

  UserInbox(
      {this.uid,
      this.lastLogin,
      this.createdAt,
      this.buildNumber,
      this.age,
      this.showAge,
      this.userName});

  factory UserInbox.fromMap(Map data) {
    return UserInbox(
        uid: data['uid'],
        lastLogin: data['lastLogin'],
        createdAt: data['createdAt'],
        buildNumber: data['buildNumber'],
        age: data['age'],
        userName: data['userName'],
        showAge: data['showAge']);
  }
}
