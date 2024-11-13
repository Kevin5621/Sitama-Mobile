import 'package:dartz/dartz.dart';
import 'package:sistem_magang/core/usecase/usecase.dart';
import 'package:sistem_magang/data/models/guidance.dart';
import 'package:sistem_magang/domain/repository/student.dart';
import 'package:sistem_magang/service_locator.dart';

class AddGuidanceUseCase implements UseCase<Either, AddGuidanceReqParams> {
  @override
  Future<Either> call({AddGuidanceReqParams? param}) async {
    return sl<StudentRepository>().addGuidances(param!);
  }
}
