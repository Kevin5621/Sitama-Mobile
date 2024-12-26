import 'package:dartz/dartz.dart';
import 'package:sitama/features/lecturer/domain/repositories/lecturer.dart';
import 'package:sitama/service_locator.dart';
import 'package:sitama/utils/usecase.dart';

class GetDetailStudentUseCase implements UseCase<Either, int> {
  @override
  Future<Either> call({int? param}) async {
    return sl<LecturerRepository>().getDetailStudent(param!);
  }
}
