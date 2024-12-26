import 'package:dartz/dartz.dart';
import 'package:sitama/core/usecase/usecase.dart';
import 'package:sitama/data/models/guidance.dart';
import 'package:sitama/domain/repository/student.dart';
import 'package:sitama/service_locator.dart';

class AddGuidanceUseCase implements UseCase<Either, AddGuidanceReqParams> {
  @override
  Future<Either> call({AddGuidanceReqParams? param}) async {
    return sl<StudentRepository>().addGuidances(param!);
  }
}
