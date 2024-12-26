import 'package:sitama/core/usecase/usecase.dart';
import 'package:sitama/domain/repository/auth.dart';
import 'package:sitama/service_locator.dart';

class LogoutUseCase implements UseCase<dynamic, dynamic> {
  @override
  Future call({dynamic param}) async {
    return sl<AuthRepostory>().logout();
  }
}
