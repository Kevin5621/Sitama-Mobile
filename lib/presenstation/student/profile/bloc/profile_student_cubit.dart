import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/domain/usecases/get_profile_student.dart';
import 'package:sistem_magang/presenstation/student/profile/bloc/profile_student_state.dart';
import 'package:sistem_magang/service_locator.dart';

class ProfileStudentCubit extends Cubit<ProfileStudentState> {
  ProfileStudentCubit() : super(StudentLoading());

  void displayStudent() async {
    var result = await sl<GetProfileStudentUseCase>().call();
    result.fold(
      (error) {
        emit(LoadStudentFailure(errorMessage: error));
      },
      (data) {
        emit(StudentLoaded(studentProfileEntity: data));
      },
    );
  }
}
