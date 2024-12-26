import 'package:sitama/features/auth/domain/repositories/auth.dart';
import 'package:sitama/service_locator.dart';
import 'package:sitama/utils/usecase.dart';

class IsLoggedInUseCase implements UseCase<bool, dynamic> {
  @override
  Future<bool> call({dynamic param}) async {
    return sl<AuthRepostory>().isLoggedIn();
  }
}
