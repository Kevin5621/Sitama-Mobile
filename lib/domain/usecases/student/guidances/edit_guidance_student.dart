import 'package:dartz/dartz.dart';
import 'package:sitama/core/usecase/usecase.dart';
import 'package:sitama/data/models/guidance.dart';
import 'package:sitama/domain/repository/student.dart';
import 'package:sitama/service_locator.dart';

class EditGuidanceUseCase implements UseCase<Either, EditGuidanceReqParams> {
  @override
  Future<Either> call({EditGuidanceReqParams? param}) async {
    return sl<StudentRepository>().editGuidances(param!);
  }
}
