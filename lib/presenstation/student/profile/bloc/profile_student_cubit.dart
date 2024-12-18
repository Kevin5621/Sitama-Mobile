import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Sitama/domain/usecases/student/general/get_profile_student.dart';
import 'package:Sitama/presenstation/student/profile/bloc/profile_student_state.dart';
import 'package:Sitama/service_locator.dart';

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
