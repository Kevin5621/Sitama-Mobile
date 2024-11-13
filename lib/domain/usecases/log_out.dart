import 'package:sistem_magang/core/usecase/usecase.dart';
import 'package:sistem_magang/domain/repository/auth.dart';
import 'package:sistem_magang/service_locator.dart';

class LogoutUseCase implements UseCase<dynamic, dynamic> {
  @override
  Future call({dynamic param}) async {
    return sl<AuthRepostory>().logout();
  }
}
