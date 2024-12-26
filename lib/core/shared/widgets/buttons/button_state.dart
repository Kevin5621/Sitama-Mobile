abstract class ButtonState {}

class ButtonInitialState extends ButtonState {}

class ButtonLoadingState extends ButtonState {}

class ButtonSuccessState extends ButtonState {}

class ButtonFailurState extends ButtonState {
  final String errorMessage;

  ButtonFailurState({required this.errorMessage});
}