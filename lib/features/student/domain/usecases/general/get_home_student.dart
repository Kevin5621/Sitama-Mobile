import 'package:dartz/dartz.dart';
import 'package:sitama/features/auth/data/models/signin_req_params.dart';
import 'package:sitama/features/student/domain/repositories/student.dart';
import 'package:sitama/service_locator.dart';
import 'package:sitama/utils/usecase.dart';

class GetHomeStudentUseCase implements UseCase<Either, SigninReqParams> {
  @override
  Future<Either> call({dynamic param}) async {
    return sl<StudentRepository>().getStudentHome();
  }
}
