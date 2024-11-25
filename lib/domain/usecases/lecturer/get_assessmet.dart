import 'package:dartz/dartz.dart';
import 'package:sistem_magang/core/usecase/usecase.dart';
import 'package:sistem_magang/domain/repository/lecturer.dart';
import 'package:sistem_magang/service_locator.dart';

class GetAssessments implements UseCase<Either, int> {
  @override
  Future<Either> call({int? param}) async {
    return sl<LecturerRepository>().fetchAssessments(param!);
  }
}
