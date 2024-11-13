import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/domain/usecases/lecturer/get_profile_lecturer.dart';
import 'package:sistem_magang/presenstation/lecturer/profile/bloc/profile_lecturer_state.dart';
import 'package:sistem_magang/service_locator.dart';

class ProfileLecturerCubit extends Cubit<ProfileLecturerState> {
  ProfileLecturerCubit() : super(LecturerLoading());

  void displayLecturer() async {
    var result = await sl<GetProfileLecturerUseCase>().call();
    result.fold(
      (error) {
        emit(LoadLecturerFailure(errorMessage: error));
      },
      (data) {
        emit(LecturerLoaded(lecturerProfileEntity: data));
      },
    );
  }
}
