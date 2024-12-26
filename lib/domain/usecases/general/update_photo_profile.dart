import 'package:dartz/dartz.dart';
import 'package:sitama/core/usecase/usecase.dart';
import 'package:sitama/data/models/update_profile_req_params.dart';
import 'package:sitama/domain/repository/auth.dart';
import 'package:sitama/service_locator.dart';

class UpdatePhotoProfileUseCase implements UseCase<Either, UpdateProfileReqParams> {
  @override
  Future<Either> call({UpdateProfileReqParams? param}) async {
    return sl<AuthRepostory>().updatePhotoProfile(param!);
  }
}
