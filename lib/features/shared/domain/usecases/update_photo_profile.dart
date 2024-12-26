import 'package:dartz/dartz.dart';
import 'package:sitama/features/auth/domain/repositories/auth.dart';
import 'package:sitama/features/shared/data/models/update_profile_req_params.dart';
import 'package:sitama/service_locator.dart';
import 'package:sitama/utils/usecase.dart';

class UpdatePhotoProfileUseCase implements UseCase<Either, UpdateProfileReqParams> {
  @override
  Future<Either> call({UpdateProfileReqParams? param}) async {
    return sl<AuthRepostory>().updatePhotoProfile(param!);
  }
}
