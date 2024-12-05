import 'package:sistem_magang/data/repository/auth.dart';
import 'package:sistem_magang/domain/repository/auth.dart';

class ForgotPasswordUseCase {
  final AuthRepostory _repository;

  ForgotPasswordUseCase(this._repository);

  Future<void> execute(String email) async {
    if (!_isValidEmail(email)) {
      throw AuthException(message: 'Invalid email format');
    }
    
    await _repository.forgotPassword(email);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}