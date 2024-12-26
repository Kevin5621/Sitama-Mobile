import 'package:dartz/dartz.dart';
import 'package:sitama/features/student/domain/repositories/student.dart';
import 'package:sitama/service_locator.dart';
import 'package:sitama/utils/usecase.dart';

class GetLogBookStudentUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({dynamic param}) async {
    return sl<StudentRepository>().getLogBook();
  }
}
