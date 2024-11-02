import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/domain/usecases/get_detail_student.dart';
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
          isChecked: false, // Default checkbox tidak dicentang
          isStarRounded: false, // Default bintang tidak terpilih
        ));
      },
    );
  }

  void toggleCheck() {
    if (state is DetailLoaded) {
      final currentState = state as DetailLoaded;
      emit(DetailLoaded(
        detailStudentEntity: currentState.detailStudentEntity,
        isChecked: !currentState.isChecked, // Toggle status checkbox
        isStarRounded: currentState.isStarRounded, // Pertahankan status bintang
      ));
    }
  }

  void toggleStar() {
    if (state is DetailLoaded) {
      final currentState = state as DetailLoaded;
      emit(DetailLoaded(
        detailStudentEntity: currentState.detailStudentEntity,
        isChecked: currentState.isChecked, // Pertahankan status checkbox
        isStarRounded: !currentState.isStarRounded, // Toggle status bintang
      ));
    }
  }
}
