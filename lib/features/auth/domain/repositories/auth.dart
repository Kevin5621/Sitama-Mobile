import 'package:dartz/dartz.dart';
import 'package:sitama/features/auth/data/models/reset_password_req_params.dart';
import 'package:sitama/features/auth/data/models/signin_google_req_params.dart';
import 'package:sitama/features/auth/data/models/signin_req_params.dart';
import 'package:sitama/features/shared/data/models/update_profile_req_params.dart';

abstract class AuthRepostory {

  Future<Either> signin(SigninReqParams request);
  Future<bool> isLoggedIn();
  Future<Either> logout();
  Future<Either> resetPassword(ResetPasswordReqParams request);

  Future<Either> signinGoogle(SigninGoogleReqParams request);

  Future<Either> updatePhotoProfile(UpdateProfileReqParams request);
} 