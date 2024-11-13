import 'package:dartz/dartz.dart';
import 'package:sistem_magang/core/usecase/usecase.dart';
import 'package:sistem_magang/data/models/signin_req_params.dart';
import 'package:sistem_magang/domain/repository/auth.dart';
import 'package:sistem_magang/service_locator.dart';

class SigninUseCase implements UseCase<Either, SigninReqParams>{

  @override
  Future<Either> call({SigninReqParams ? param}) async {
    return sl<AuthRepostory>().signin(param!);
  }

}