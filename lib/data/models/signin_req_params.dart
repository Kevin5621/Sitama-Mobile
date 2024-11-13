
class SigninReqParams {
  final String username;
  final String password;

  SigninReqParams({required this.username, required this.password});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'password': password,
    };
  }
}
