

import 'package:dartz/dartz.dart';
import 'package:Sitama/core/usecase/usecase.dart';
import 'package:Sitama/data/models/log_book.dart';
import 'package:Sitama/domain/repository/lecturer.dart';
import 'package:Sitama/service_locator.dart';

class UpdateLogBookNoteUseCase implements UseCase<Either, UpdateLogBookReqParams> {
  @override
  Future<Either> call({UpdateLogBookReqParams? param}) async {
    return sl<LecturerRepository>().updateLogBookNote(param!);
  }
}