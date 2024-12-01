import 'package:dartz/dartz.dart';
import 'package:sistem_magang/core/usecase/usecase.dart';
import 'package:sistem_magang/data/models/guidance.dart';
import 'package:sistem_magang/domain/repository/lecturer.dart';
import 'package:sistem_magang/service_locator.dart';

class UpdateFinishedStudentUseCase implements UseCase<Either, UpdateFinishedStudentReqParams> {
  @override
  Future<Either> call({UpdateFinishedStudentReqParams? param}) async {
    return sl<LecturerRepository>().updateFinishedStudent(param!);
  }
}