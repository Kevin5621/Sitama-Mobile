import 'package:dartz/dartz.dart';
import 'package:Sitama/core/usecase/usecase.dart';
import 'package:Sitama/domain/repository/lecturer.dart';
import 'package:Sitama/service_locator.dart';

class GetDetailStudentUseCase implements UseCase<Either, int> {
  @override
  Future<Either> call({int? param}) async {
    return sl<LecturerRepository>().getDetailStudent(param!);
  }
}
