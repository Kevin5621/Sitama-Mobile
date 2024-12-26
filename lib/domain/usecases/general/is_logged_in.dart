import 'package:sitama/core/usecase/usecase.dart';
import 'package:sitama/domain/repository/auth.dart';
import 'package:sitama/service_locator.dart';

class IsLoggedInUseCase implements UseCase<bool, dynamic> {
  @override
  Future<bool> call({dynamic param}) async {
    return sl<AuthRepostory>().isLoggedIn();
  }
}
