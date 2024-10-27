import 'package:dartz/dartz.dart';
import 'package:sistem_magang/core/usecase/usecase.dart';
import 'package:sistem_magang/data/models/log_book.dart';
import 'package:sistem_magang/domain/repository/student.dart';
import 'package:sistem_magang/service_locator.dart';

class AddLogBookUseCase implements UseCase<Either, AddLogBookReqParams> {
  @override
  Future<Either> call({AddLogBookReqParams? param}) async {
    return sl<StudentRepository>().addLogBook(param!);
  }
}