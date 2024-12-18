import 'package:dartz/dartz.dart';
import 'package:Sitama/core/usecase/usecase.dart';
import 'package:Sitama/data/models/signin_req_params.dart';
import 'package:Sitama/domain/repository/student.dart';
import 'package:Sitama/service_locator.dart';

class GetHomeStudentUseCase implements UseCase<Either, SigninReqParams> {
  @override
  Future<Either> call({dynamic param}) async {
    return sl<StudentRepository>().getStudentHome();
  }
}
