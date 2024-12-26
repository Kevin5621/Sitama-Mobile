

import 'package:dartz/dartz.dart';
import 'package:sitama/core/usecase/usecase.dart';
import 'package:sitama/data/models/log_book.dart';
import 'package:sitama/domain/repository/lecturer.dart';
import 'package:sitama/service_locator.dart';

class UpdateLogBookNoteUseCase implements UseCase<Either, UpdateLogBookReqParams> {
  @override
  Future<Either> call({UpdateLogBookReqParams? param}) async {
    return sl<LecturerRepository>().updateLogBookNote(param!);
  }
}