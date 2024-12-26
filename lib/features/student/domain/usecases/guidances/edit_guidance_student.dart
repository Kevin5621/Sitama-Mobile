import 'package:dartz/dartz.dart';
import 'package:sitama/features/shared/data/models/guidance.dart';
import 'package:sitama/features/student/domain/repositories/student.dart';
import 'package:sitama/service_locator.dart';
import 'package:sitama/utils/usecase.dart';

class EditGuidanceUseCase implements UseCase<Either, EditGuidanceReqParams> {
  @override
  Future<Either> call({EditGuidanceReqParams? param}) async {
    return sl<StudentRepository>().editGuidances(param!);
  }
}
