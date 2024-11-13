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
        // Inisialisasi Map untuk status approval internship
        final internshipApprovalStatus = Map<int, bool>.fromIterable(
          Iterable.generate(data.internships.length),
          key: (i) => i,
          value: (_) => false,
        );

        emit(DetailLoaded(
          detailStudentEntity: data,
          internshipApprovalStatus: internshipApprovalStatus,
          isStarRounded: false,
        ));
      },
    );
  }

  void toggleInternshipApproval(int index) {
    if (state is DetailLoaded) {
      final currentState = state as DetailLoaded;
      final newApprovalStatus = Map<int, bool>.from(currentState.internshipApprovalStatus);
      newApprovalStatus[index] = !(newApprovalStatus[index] ?? false);

      emit(currentState.copyWith(
        internshipApprovalStatus: newApprovalStatus,
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

  // Optional: Method untuk mengatur semua status approval sekaligus
  void setAllInternshipApproval(bool approved) {
    if (state is DetailLoaded) {
      final currentState = state as DetailLoaded;
      final newApprovalStatus = Map<int, bool>.fromIterable(
        currentState.internshipApprovalStatus.keys,
        key: (k) => k,
        value: (_) => approved,
      );

      emit(currentState.copyWith(
        internshipApprovalStatus: newApprovalStatus,
      ));
    }
  }
}