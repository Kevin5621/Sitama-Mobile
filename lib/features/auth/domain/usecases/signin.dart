import 'package:dartz/dartz.dart';
import 'package:sitama/features/auth/data/models/signin_req_params.dart';
import 'package:sitama/features/auth/domain/repositories/auth.dart';
import 'package:sitama/service_locator.dart';
import 'package:sitama/utils/usecase.dart';

class SigninUseCase implements UseCase<Either, SigninReqParams>{

  @override
  Future<Either> call({SigninReqParams ? param}) async {
    return sl<AuthRepostory>().signin(param!);
  }

}