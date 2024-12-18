import 'package:dartz/dartz.dart';
import 'package:Sitama/core/usecase/usecase.dart';
import 'package:Sitama/domain/repository/lecturer.dart';
import 'package:Sitama/service_locator.dart';

class GetHomeLecturerUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({dynamic param}) async {
    return sl<LecturerRepository>().getLecturerHome();
  }
}
