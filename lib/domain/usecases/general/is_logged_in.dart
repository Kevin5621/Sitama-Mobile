import 'package:Sitama/core/usecase/usecase.dart';
import 'package:Sitama/domain/repository/auth.dart';
import 'package:Sitama/service_locator.dart';

class IsLoggedInUseCase implements UseCase<bool, dynamic> {
  @override
  Future<bool> call({dynamic param}) async {
    return sl<AuthRepostory>().isLoggedIn();
  }
}
