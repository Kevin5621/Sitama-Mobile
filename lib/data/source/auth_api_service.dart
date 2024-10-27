import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sistem_magang/core/constansts/api_urls.dart';
import 'package:sistem_magang/core/network/dio_client.dart';
import 'package:sistem_magang/data/models/signin_req_params.dart';
import 'package:sistem_magang/service_locator.dart';

abstract class AuthApiService {
  Future<Either> signin(SigninReqParams request);
}

class AuthApiServiceImpl extends AuthApiService {
  @override
  Future<Either> signin(SigninReqParams request) async {
    try {
      var response =
          await sl<DioClient>().post(ApiUrls.login, data: request.toMap());

      return Right(response);
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(e.response!.data['errors']['message'].toString());
      } else {
        return Left(e.message);
      }
    }
  }
}