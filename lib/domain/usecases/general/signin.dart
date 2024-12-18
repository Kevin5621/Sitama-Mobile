import 'package:dartz/dartz.dart';
import 'package:Sitama/core/usecase/usecase.dart';
import 'package:Sitama/data/models/signin_req_params.dart';
import 'package:Sitama/domain/repository/auth.dart';
import 'package:Sitama/service_locator.dart';

class SigninUseCase implements UseCase<Either, SigninReqParams>{

  @override
  Future<Either> call({SigninReqParams ? param}) async {
    return sl<AuthRepostory>().signin(param!);
  }

}