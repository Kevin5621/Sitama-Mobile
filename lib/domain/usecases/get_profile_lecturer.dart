import 'package:dartz/dartz.dart';
import 'package:sistem_magang/core/usecase/usecase.dart';
import 'package:sistem_magang/domain/repository/lecturer.dart';
import 'package:sistem_magang/service_locator.dart';

class GetProfileLecturerUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({dynamic param}) async {
    return sl<LecturerRepository>().getLecturerProfile();
  }
}
