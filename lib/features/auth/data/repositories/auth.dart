import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sitama/features/auth/data/models/reset_password_req_params.dart';
import 'package:sitama/features/auth/data/models/signin_google_req_params.dart';
import 'package:sitama/features/auth/data/models/signin_req_params.dart';
import 'package:sitama/features/auth/data/sources/auth_api_service.dart';
import 'package:sitama/features/auth/data/sources/auth_local_service.dart';
import 'package:sitama/features/auth/domain/repositories/auth.dart';
import 'package:sitama/features/shared/data/models/update_profile_req_params.dart';
import 'package:sitama/service_locator.dart';

class AuthRepostoryImpl extends AuthRepostory{

  @override
  Future<Either> signin(SigninReqParams request) async {
    Either result = await sl<AuthApiService>().signin(request);
    return result.fold(
      (error) {
        return Left(error);
      }, 
      (data) async {
        Response response = data;
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString('token', response.data['data']['token']);
        sharedPreferences.setString('role', response.data['data']['role']);
        return Right(response);
      }
    );
  }
  
  @override
  Future<bool> isLoggedIn() async {
    return await sl<AuthLocalService>().isLoggedIn();
  }
  
  @override
  Future<Either> logout() async {
    Either resullt = await sl<AuthLocalService>().logout();
    return resullt;
  }

  @override
  Future<Either> updatePhotoProfile(UpdateProfileReqParams request) async {
    Either result = await sl<AuthApiService>().updatePhotoProfile(request);
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }
  
  @override
  Future<Either> resetPassword(ResetPasswordReqParams request) async {
    Either result = await sl<AuthApiService>().resetPassword(request);
    return result.fold(
      (error) => Left(error),
      (data) => Right(data),
    );
  }

  @override
  Future<Either> signinGoogle(SigninGoogleReqParams request) async {
    Either result = await sl<AuthApiService>().signinGoogle(request);
    return result.fold(
            (error) {
          return Left(error);
        },
            (data) async {
          Response response = data;
          return Right(response);
        }
    );
  }
}

class AuthException implements Exception {
  final String message;
  
  AuthException({required this.message});
}