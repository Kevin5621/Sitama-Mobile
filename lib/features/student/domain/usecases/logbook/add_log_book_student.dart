import 'package:dartz/dartz.dart';
import 'package:sitama/features/shared/data/models/log_book.dart';
import 'package:sitama/features/student/domain/repositories/student.dart';
import 'package:sitama/service_locator.dart';
import 'package:sitama/utils/usecase.dart';

class AddLogBookUseCase implements UseCase<Either, AddLogBookReqParams> {
  @override
  Future<Either> call({AddLogBookReqParams? param}) async {
    return sl<StudentRepository>().addLogBook(param!);
  }
}
