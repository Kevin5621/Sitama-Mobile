import 'package:dartz/dartz.dart';
import 'package:sitama/features/lecturer/domain/repositories/lecturer.dart';
import 'package:sitama/features/shared/data/models/guidance.dart';
import 'package:sitama/service_locator.dart';
import 'package:sitama/utils/usecase.dart';

class UpdateStatusGuidanceUseCase implements UseCase<Either, UpdateStatusGuidanceReqParams> {
  @override
  Future<Either> call({UpdateStatusGuidanceReqParams? param}) async {
    return sl<LecturerRepository>().updateStatusGuidance(param!);
  }
}
