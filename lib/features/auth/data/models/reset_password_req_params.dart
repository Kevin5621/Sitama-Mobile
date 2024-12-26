class ResetPasswordReqParams {
  final String oldPassword;
  final String newPassword;

  ResetPasswordReqParams({
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toMap() {
    return {
      'password': oldPassword,
      'new_password': newPassword,
    };
  }
}