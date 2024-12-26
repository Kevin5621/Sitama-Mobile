import 'package:dartz/dartz.dart';
import 'package:sitama/core/usecase/usecase.dart';
import 'package:sitama/domain/repository/lecturer.dart';
import 'package:sitama/service_locator.dart';

class GetHomeLecturerUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({dynamic param}) async {
    return sl<LecturerRepository>().getLecturerHome();
  }
}
