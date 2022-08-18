class Users {
  final String uid;

  Users({this.uid});
}

class UserData {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String mobileNum;
  final String username;
  final String birthDate;

  UserData(
      {this.uid,
      this.email,
      this.firstName,
      this.lastName,
      this.mobileNum,
      this.username,
      this.birthDate});
}
