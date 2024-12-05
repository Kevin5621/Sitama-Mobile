import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/bloc/bloc/forgot_password_state.dart';
import 'package:sistem_magang/data/repository/auth.dart';
import 'package:sistem_magang/domain/usecases/general/forgot_password.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordCubit(this._forgotPasswordUseCase) 
      : super(ForgotPasswordInitial());

  Future<void> forgotPassword(String email) async {
    emit(ForgotPasswordLoading());

    try {
      await _forgotPasswordUseCase.execute(email);
      emit(ForgotPasswordSuccess());
    } on AuthException catch (e) {
      emit(ForgotPasswordError(e.message));
    }
  }
}
