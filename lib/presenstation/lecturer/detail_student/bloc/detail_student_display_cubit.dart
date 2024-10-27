import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/domain/usecases/get_detail_student.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/bloc/detail_student_display_state.dart';
import 'package:sistem_magang/service_locator.dart';

class DetailStudentDisplayCubit extends Cubit<DetailStudentDisplayState> {
  DetailStudentDisplayCubit() : super(LecturerLoading());

  void displayStudent(int id) async {
    var result = await sl<GetDetailStudentUseCase>().call(param: id);
    result.fold(
      (error) {
        emit(LoadLecturerFailure(errorMessage: error));
      },
      (data) {
        emit(LecturerLoaded(detailStudentEntity: data));
      },
    );
  }
}