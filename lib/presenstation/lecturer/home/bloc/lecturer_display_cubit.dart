import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';
import 'package:sistem_magang/domain/usecases/get_home_lecturer.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/lecturer_display_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/service_locator.dart';

class LecturerDisplayCubit extends Cubit<LecturerDisplayState> {
  final SelectionBloc selectionBloc;
  LecturerHomeEntity? _cachedData;

  LecturerDisplayCubit({required this.selectionBloc}) : super(LecturerLoading()) {
    selectionBloc.stream.listen((selectionState) {
      if (state is LecturerLoaded && !selectionState.isLocalOperation) {
        displayLecturer();
      }
    });
  }

  void displayLecturer() async {
    // Don't show loading state if we have cached data
    if (_cachedData == null) {
      emit(LecturerLoading());
    }

    var result = await sl<GetHomeLecturerUseCase>().call();
    result.fold(
      (error) {
        emit(LoadLecturerFailure(errorMessage: error));
      },
      (data) {
        _cachedData = data;
        if (data.students != null) {
          emit(LecturerLoaded(lecturerHomeEntity: data));
        }
      },
    );
  }

  // Method untuk update lokal tanpa loading
  void updateLocalData(LecturerHomeEntity newData) {
    _cachedData = newData;
    emit(LecturerLoaded(lecturerHomeEntity: newData));
  }
}