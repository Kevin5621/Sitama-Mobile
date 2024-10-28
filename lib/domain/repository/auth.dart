import 'package:dartz/dartz.dart';
import 'package:sistem_magang/data/models/signin_req_params.dart';
import 'package:sistem_magang/data/models/update_profile_req_params.dart';

abstract class AuthRepostory {

  Future<Either> signin(SigninReqParams request);
  Future<bool> isLoggedIn();
  Future<Either> logout();

  Future<Either> updatePhotoProfile(UpdateProfileReqParams request);
  
} 