import 'package:dartz/dartz.dart';
import 'package:sistem_magang/core/usecase/usecase.dart';
import 'package:sistem_magang/data/models/update_profile_req_params.dart';
import 'package:sistem_magang/domain/repository/auth.dart';
import 'package:sistem_magang/service_locator.dart';

class UpdatePhotoProfileUseCase implements UseCase<Either, UpdateProfileReqParams> {
  @override
  Future<Either> call({UpdateProfileReqParams? param}) async {
    return sl<AuthRepostory>().updatePhotoProfile(param!);
  }
}
