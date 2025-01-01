class SigninGoogleReqParams {
  final String token;

  SigninGoogleReqParams({required this.token});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idToken': token,
    };
  }
}