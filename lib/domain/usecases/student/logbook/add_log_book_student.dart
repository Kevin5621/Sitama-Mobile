import 'package:dartz/dartz.dart';
import 'package:sitama/core/usecase/usecase.dart';
import 'package:sitama/data/models/log_book.dart';
import 'package:sitama/domain/repository/student.dart';
import 'package:sitama/service_locator.dart';

class AddLogBookUseCase implements UseCase<Either, AddLogBookReqParams> {
  @override
  Future<Either> call({AddLogBookReqParams? param}) async {
    return sl<StudentRepository>().addLogBook(param!);
  }
}
