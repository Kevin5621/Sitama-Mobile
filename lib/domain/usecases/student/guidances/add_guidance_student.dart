import 'package:dartz/dartz.dart';
import 'package:Sitama/core/usecase/usecase.dart';
import 'package:Sitama/data/models/guidance.dart';
import 'package:Sitama/domain/repository/student.dart';
import 'package:Sitama/service_locator.dart';

class AddGuidanceUseCase implements UseCase<Either, AddGuidanceReqParams> {
  @override
  Future<Either> call({AddGuidanceReqParams? param}) async {
    return sl<StudentRepository>().addGuidances(param!);
  }
}
