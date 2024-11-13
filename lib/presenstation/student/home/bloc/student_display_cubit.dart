import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/domain/usecases/student/general/get_home_student.dart';
import 'package:sistem_magang/presenstation/student/home/bloc/student_display_state.dart';
import 'package:sistem_magang/service_locator.dart';

class StudentDisplayCubit extends Cubit<StudentDisplayState> {
  StudentDisplayCubit() : super(StudentLoading());

  void displayStudent() async {
    var result = await sl<GetHomeStudentUseCase>().call();
    result.fold(
      (error) {
        emit(LoadStudentFailure(errorMessage: error));
      },
      (data) {
        emit(StudentLoaded(studentHomeEntity: data));
      },
    );
  }
}