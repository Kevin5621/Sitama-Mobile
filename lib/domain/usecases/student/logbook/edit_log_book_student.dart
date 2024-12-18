import 'package:dartz/dartz.dart';
import 'package:Sitama/core/usecase/usecase.dart';
import 'package:Sitama/data/models/log_book.dart';
import 'package:Sitama/domain/repository/student.dart';
import 'package:Sitama/service_locator.dart';

class EditLogBookUseCase implements UseCase<Either, EditLogBookReqParams> {
  @override
  Future<Either> call({EditLogBookReqParams? param}) async {
    return sl<StudentRepository>().editLogBook(param!);
  }
}
