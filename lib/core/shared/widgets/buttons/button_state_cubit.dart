import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/core/shared/widgets/buttons/button_state.dart';
import 'package:sitama/utils/usecase.dart';

class ButtonStateCubit extends Cubit<ButtonState> {
  ButtonStateCubit() : super(ButtonInitialState());

  void startLoading() {
    emit(ButtonLoadingState());
  }

  void resetState() {
    emit(ButtonInitialState());
  }

  void excute({dynamic params, required UseCase usecase}) async {
    startLoading();
    
    try {
      Either result = await usecase.call(param: params);

      result.fold(
        (error) {
          emit(ButtonFailurState(errorMessage: error));
        }, 
        (data) {
          emit(ButtonSuccessState());
        },
      );
    } catch (e) {
      emit(ButtonFailurState(errorMessage: e.toString()));
    }
  }
}