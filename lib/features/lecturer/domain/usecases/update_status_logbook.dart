import 'package:dartz/dartz.dart';
import 'package:sitama/features/lecturer/domain/repositories/lecturer.dart';
import 'package:sitama/features/shared/data/models/log_book.dart';
import 'package:sitama/service_locator.dart';
import 'package:sitama/utils/usecase.dart';

class UpdateLogBookNoteUseCase implements UseCase<Either, UpdateLogBookReqParams> {
  @override
  Future<Either> call({UpdateLogBookReqParams? param}) async {
    return sl<LecturerRepository>().updateLogBookNote(param!);
  }
}