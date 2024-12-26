import 'package:dartz/dartz.dart';
import 'package:sitama/core/usecase/usecase.dart';
import 'package:sitama/data/models/signin_req_params.dart';
import 'package:sitama/domain/repository/student.dart';
import 'package:sitama/service_locator.dart';

class GetHomeStudentUseCase implements UseCase<Either, SigninReqParams> {
  @override
  Future<Either> call({dynamic param}) async {
    return sl<StudentRepository>().getStudentHome();
  }
}
