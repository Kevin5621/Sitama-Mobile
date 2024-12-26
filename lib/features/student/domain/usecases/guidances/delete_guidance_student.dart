import 'package:dartz/dartz.dart';
import 'package:sitama/features/student/domain/repositories/student.dart';
import 'package:sitama/service_locator.dart';
import 'package:sitama/utils/usecase.dart';

class DeleteGuidanceUseCase implements UseCase<Either, int> {
  @override
  Future<Either> call({int? param}) async {
    return sl<StudentRepository>().deleteGuidances(param!);
  }
}
