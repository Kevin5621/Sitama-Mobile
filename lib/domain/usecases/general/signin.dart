import 'package:dartz/dartz.dart';
import 'package:sitama/core/usecase/usecase.dart';
import 'package:sitama/data/models/signin_req_params.dart';
import 'package:sitama/domain/repository/auth.dart';
import 'package:sitama/service_locator.dart';

class SigninUseCase implements UseCase<Either, SigninReqParams>{

  @override
  Future<Either> call({SigninReqParams ? param}) async {
    return sl<AuthRepostory>().signin(param!);
  }

}