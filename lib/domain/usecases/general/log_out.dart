import 'package:Sitama/core/usecase/usecase.dart';
import 'package:Sitama/domain/repository/auth.dart';
import 'package:Sitama/service_locator.dart';

class LogoutUseCase implements UseCase<dynamic, dynamic> {
  @override
  Future call({dynamic param}) async {
    return sl<AuthRepostory>().logout();
  }
}
