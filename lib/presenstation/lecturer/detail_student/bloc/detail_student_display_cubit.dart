import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/domain/usecases/lecturer/get_detail_student.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/bloc/detail_student_display_state.dart';
import 'package:sistem_magang/service_locator.dart';

class DetailStudentDisplayCubit extends Cubit<DetailStudentDisplayState> {
  DetailStudentDisplayCubit() : super(DetailLoading());

  void displayStudent(int id) async {
    var result = await sl<GetDetailStudentUseCase>().call(param: id);
    result.fold(
      (error) {
        emit(DetailFailure(errorMessage: error));
      },
      (data) {
        emit(DetailLoaded(
          detailStudentEntity: data,
          isStarRounded: false,
        ));
      },
    );
  }

  void toggleInternshipCompletion(int index) {
    if (state is DetailLoaded) {
      final currentState = state as DetailLoaded;
      final updatedEntity = currentState.detailStudentEntity.copyWith(
        is_finished: !(currentState.detailStudentEntity.is_finished ?? false)
      );

      emit(currentState.copyWith(
        detailStudentEntity: updatedEntity,
      ));
    }
  }

  void toggleStar() {
    if (state is DetailLoaded) {
      final currentState = state as DetailLoaded;
      emit(currentState.copyWith(
        isStarRounded: !currentState.isStarRounded,
      ));
    }
  }
}