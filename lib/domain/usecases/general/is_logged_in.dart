import 'package:sistem_magang/core/usecase/usecase.dart';
import 'package:sistem_magang/domain/repository/auth.dart';
import 'package:sistem_magang/service_locator.dart';

class IsLoggedInUseCase implements UseCase<bool, dynamic> {
  @override
  Future<bool> call({dynamic param}) async {
    return sl<AuthRepostory>().isLoggedIn();
  }
}
