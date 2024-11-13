import 'package:dartz/dartz.dart';
import 'package:sistem_magang/core/usecase/usecase.dart';
import 'package:sistem_magang/domain/repository/student.dart';
import 'package:sistem_magang/service_locator.dart';

class DeleteGuidanceUseCase implements UseCase<Either, int> {
  @override
  Future<Either> call({int? param}) async {
    return sl<StudentRepository>().deleteGuidances(param!);
  }
}
