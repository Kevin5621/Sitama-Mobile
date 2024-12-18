import 'package:dartz/dartz.dart';
import 'package:Sitama/core/usecase/usecase.dart';
import 'package:Sitama/data/models/update_profile_req_params.dart';
import 'package:Sitama/domain/repository/auth.dart';
import 'package:Sitama/service_locator.dart';

class UpdatePhotoProfileUseCase implements UseCase<Either, UpdateProfileReqParams> {
  @override
  Future<Either> call({UpdateProfileReqParams? param}) async {
    return sl<AuthRepostory>().updatePhotoProfile(param!);
  }
}
