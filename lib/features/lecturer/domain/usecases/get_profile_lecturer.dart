import 'package:dartz/dartz.dart';
import 'package:sitama/features/lecturer/domain/repositories/lecturer.dart';
import 'package:sitama/service_locator.dart';
import 'package:sitama/utils/usecase.dart';

class GetProfileLecturerUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({dynamic param}) async {
    return sl<LecturerRepository>().getLecturerProfile();
  }
}
