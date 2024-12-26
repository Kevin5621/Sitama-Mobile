import 'package:dartz/dartz.dart';
import 'package:sitama/features/shared/data/models/guidance.dart';
import 'package:sitama/features/student/domain/repositories/student.dart';
import 'package:sitama/service_locator.dart';
import 'package:sitama/utils/usecase.dart';

class AddGuidanceUseCase implements UseCase<Either, AddGuidanceReqParams> {
  @override
  Future<Either> call({AddGuidanceReqParams? param}) async {
    return sl<StudentRepository>().addGuidances(param!);
  }
}
