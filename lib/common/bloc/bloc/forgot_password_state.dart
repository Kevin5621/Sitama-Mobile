abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}
class ForgotPasswordLoading extends ForgotPasswordState {}
class ForgotPasswordSuccess extends ForgotPasswordState {}
class ForgotPasswordError extends ForgotPasswordState {
  final String errorMessage;
  
  ForgotPasswordError(this.errorMessage);
}