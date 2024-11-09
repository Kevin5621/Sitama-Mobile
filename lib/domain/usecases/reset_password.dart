import 'package:dartz/dartz.dart';
import 'package:sistem_magang/data/models/reset_password_req_params.dart';
import 'package:sistem_magang/domain/repository/auth.dart';
import 'package:sistem_magang/service_locator.dart';

class ResetPasswordUseCase {
  Future<Either> execute(ResetPasswordReqParams request) async {
    return await sl<AuthRepostory>().resetPassword(request);
  }
}
