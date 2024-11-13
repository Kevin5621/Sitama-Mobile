import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/domain/usecases/get_home_lecturer.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/lecturer_display_state.dart';
import 'package:sistem_magang/service_locator.dart';

class LecturerDisplayCubit extends Cubit<LecturerDisplayState> {
  LecturerDisplayCubit() : super(LecturerLoading());

  void displayLecturer() async {
    var result = await sl<GetHomeLecturerUseCase>().call();
    result.fold(
      (error) {
        emit(LoadLecturerFailure(errorMessage: error));
      },
      (data) {
        emit(LecturerLoaded(lecturerHomeEntity: data));
      },
    );
  }
}