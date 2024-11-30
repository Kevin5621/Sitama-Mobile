

import 'package:dartz/dartz.dart';
import 'package:sistem_magang/core/usecase/usecase.dart';
import 'package:sistem_magang/data/models/log_book.dart';
import 'package:sistem_magang/domain/repository/lecturer.dart';
import 'package:sistem_magang/service_locator.dart';

class UpdateLogBookNoteUseCase implements UseCase<Either, UpdateLogBookReqParams> {
  @override
  Future<Either> call({UpdateLogBookReqParams? param}) async {
    return sl<LecturerRepository>().updateLogBookNote(param!);
  }
}