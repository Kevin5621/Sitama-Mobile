import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sitama/core/constants/api_urls.dart';
import 'package:sitama/core/network/dio_client.dart';
import 'package:sitama/features/auth/data/models/reset_password_req_params.dart';
import 'package:sitama/features/auth/data/models/signin_google_req_params.dart';
import 'package:sitama/features/auth/data/models/signin_req_params.dart';
import 'package:sitama/features/shared/data/models/update_profile_req_params.dart';
import 'package:sitama/service_locator.dart';

abstract class AuthApiService {
  Future<Either> signin(SigninReqParams request);
  Future<Either> updatePhotoProfile(UpdateProfileReqParams request);
  Future<Either> resetPassword(ResetPasswordReqParams request);
  Future<Either> signinGoogle(SigninGoogleReqParams request);
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
  
  @override
  Future<Either> updatePhotoProfile(UpdateProfileReqParams request) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      final formData = await request.toFormData();

      var response = await sl<DioClient>().post(
        ApiUrls.updatePhotoProfile,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        data: formData,
      );

      return Right(response);
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(e.response!.data['errors'].toString());
      } else {
        return Left(e.message);
      }
    }
  }
  @override
  Future<Either> resetPassword(ResetPasswordReqParams request) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      var response = await sl<DioClient>().post(
        ApiUrls.resetPassword,  // Tambahkan URL ini di ApiUrls
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        data: request.toMap(),
      );

      return Right(response);
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(e.response!.data['errors']['message'].toString());
      } else {
        return Left(e.message);
      }
    }
  }

  @override
  Future<Either> signinGoogle(SigninGoogleReqParams request) async {
    try {
      var response =
          await sl<DioClient>().post(ApiUrls.loginGoogle, data: request.toMap());
      return Right(response);
    } on DioException catch (e) {
      print(e.response.toString());
      if (e.response != null) {
        return Left(e.response!.data['errors']['message'].toString());
      } else {
        return Left(e.message);
      }
    }
  }
}
