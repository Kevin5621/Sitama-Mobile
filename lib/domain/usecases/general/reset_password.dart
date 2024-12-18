import 'package:dartz/dartz.dart';
import 'package:Sitama/data/models/reset_password_req_params.dart';
import 'package:Sitama/domain/repository/auth.dart';
import 'package:Sitama/service_locator.dart';

class ResetPasswordUseCase {
  Future<Either> execute(ResetPasswordReqParams request) async {
    return await sl<AuthRepostory>().resetPassword(request);
  }
}
