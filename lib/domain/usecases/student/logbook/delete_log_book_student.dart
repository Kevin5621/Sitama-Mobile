import 'package:dartz/dartz.dart';
import 'package:sitama/core/usecase/usecase.dart';
import 'package:sitama/domain/repository/student.dart';
import 'package:sitama/service_locator.dart';

class DeleteLogBookUseCase implements UseCase<Either, int> {
  @override
  Future<Either> call({int? param}) async {
    return sl<StudentRepository>().deleteLogBook(param!);
  }
}
