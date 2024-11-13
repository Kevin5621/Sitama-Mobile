import 'package:dartz/dartz.dart';
import 'package:sistem_magang/core/usecase/usecase.dart';
import 'package:sistem_magang/data/models/guidance.dart';
import 'package:sistem_magang/domain/repository/student.dart';
import 'package:sistem_magang/service_locator.dart';

class EditGuidanceUseCase implements UseCase<Either, EditGuidanceReqParams> {
  @override
  Future<Either> call({EditGuidanceReqParams? param}) async {
    return sl<StudentRepository>().editGuidances(param!);
  }
}
