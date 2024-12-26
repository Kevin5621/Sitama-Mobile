import 'package:dartz/dartz.dart';
import 'package:sitama/core/usecase/usecase.dart';
import 'package:sitama/data/models/guidance.dart';
import 'package:sitama/domain/repository/lecturer.dart';
import 'package:sitama/service_locator.dart';

class UpdateStatusGuidanceUseCase implements UseCase<Either, UpdateStatusGuidanceReqParams> {
  @override
  Future<Either> call({UpdateStatusGuidanceReqParams? param}) async {
    return sl<LecturerRepository>().updateStatusGuidance(param!);
  }
}
