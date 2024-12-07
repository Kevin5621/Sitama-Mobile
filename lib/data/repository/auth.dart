import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_magang/data/models/reset_password_req_params.dart';
import 'package:sistem_magang/data/models/signin_req_params.dart';
import 'package:sistem_magang/data/models/update_profile_req_params.dart';
import 'package:sistem_magang/data/source/auth_api_service.dart';
import 'package:sistem_magang/data/source/auth_local_service.dart';
import 'package:sistem_magang/domain/repository/auth.dart';
import 'package:sistem_magang/service_locator.dart';

class AuthRepostoryImpl extends AuthRepostory{
  final FirebaseAuth _firebaseAuth;

  AuthRepostoryImpl(this._firebaseAuth);

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
  Future<Either<Exception, void>> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthException(message: e.message ?? 'Reset password failed'));
    } catch (e) {
      return Left(AuthException(message: 'An unexpected error occurred'));
    }
  }
}

class AuthException implements Exception {
  final String message;
  
  AuthException({required this.message});
}