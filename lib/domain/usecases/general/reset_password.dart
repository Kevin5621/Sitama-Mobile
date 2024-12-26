import 'package:dartz/dartz.dart';
import 'package:sitama/data/models/reset_password_req_params.dart';
import 'package:sitama/domain/repository/auth.dart';
import 'package:sitama/service_locator.dart';

class ResetPasswordUseCase {
  Future<Either> execute(ResetPasswordReqParams request) async {
    return await sl<AuthRepostory>().resetPassword(request);
  }
}
