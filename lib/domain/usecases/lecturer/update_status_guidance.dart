import 'package:dartz/dartz.dart';
import 'package:Sitama/core/usecase/usecase.dart';
import 'package:Sitama/data/models/guidance.dart';
import 'package:Sitama/domain/repository/lecturer.dart';
import 'package:Sitama/service_locator.dart';

class UpdateStatusGuidanceUseCase implements UseCase<Either, UpdateStatusGuidanceReqParams> {
  @override
  Future<Either> call({UpdateStatusGuidanceReqParams? param}) async {
    return sl<LecturerRepository>().updateStatusGuidance(param!);
  }
}
