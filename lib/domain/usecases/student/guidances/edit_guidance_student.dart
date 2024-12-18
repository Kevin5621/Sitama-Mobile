import 'package:dartz/dartz.dart';
import 'package:Sitama/core/usecase/usecase.dart';
import 'package:Sitama/data/models/guidance.dart';
import 'package:Sitama/domain/repository/student.dart';
import 'package:Sitama/service_locator.dart';

class EditGuidanceUseCase implements UseCase<Either, EditGuidanceReqParams> {
  @override
  Future<Either> call({EditGuidanceReqParams? param}) async {
    return sl<StudentRepository>().editGuidances(param!);
  }
}
