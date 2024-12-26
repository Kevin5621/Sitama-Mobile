import 'package:sitama/features/auth/domain/repositories/auth.dart';
import 'package:sitama/service_locator.dart';
import 'package:sitama/utils/usecase.dart';

class LogoutUseCase implements UseCase<dynamic, dynamic> {
  @override
  Future call({dynamic param}) async {
    return sl<AuthRepostory>().logout();
  }
}
