import 'package:dartz/dartz.dart';
import 'package:sitama/features/shared/data/models/log_book.dart';
import 'package:sitama/features/student/domain/repositories/student.dart';
import 'package:sitama/service_locator.dart';
import 'package:sitama/utils/usecase.dart';

class EditLogBookUseCase implements UseCase<Either, EditLogBookReqParams> {
  @override
  Future<Either> call({EditLogBookReqParams? param}) async {
    return sl<StudentRepository>().editLogBook(param!);
  }
}
