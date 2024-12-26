import 'package:dartz/dartz.dart';
import 'package:sitama/core/usecase/usecase.dart';
import 'package:sitama/domain/repository/lecturer.dart';
import 'package:sitama/service_locator.dart';

class GetAssessments implements UseCase<Either, int> {
  @override
  Future<Either> call({int? param}) async {
    return sl<LecturerRepository>().fetchAssessments(param!);
  }
}
