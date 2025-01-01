import 'package:dartz/dartz.dart';
import 'package:sitama/features/auth/data/models/signin_google_req_params.dart';
import 'package:sitama/features/auth/data/models/signin_req_params.dart';
import 'package:sitama/features/auth/domain/repositories/auth.dart';
import 'package:sitama/service_locator.dart';
import 'package:sitama/utils/usecase.dart';

class SigninGoogleUseCase implements UseCase<Either, SigninGoogleReqParams>{

  @override
  Future<Either> call({SigninGoogleReqParams ? param}) async {
    return sl<AuthRepostory>().signinGoogle(param!);
  }

}