import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Sitama/domain/usecases/lecturer/get_profile_lecturer.dart';
import 'package:Sitama/presenstation/lecturer/profile/bloc/profile_lecturer_state.dart';
import 'package:Sitama/service_locator.dart';

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
