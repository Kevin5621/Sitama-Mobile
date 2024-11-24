import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/domain/usecases/lecturer/get_assessmet.dart';
import 'package:sistem_magang/presenstation/lecturer/input_score/bloc/assessment_state.dart';
import 'package:sistem_magang/service_locator.dart';

class AssessmentCubit extends Cubit<AssessmentState> {
  AssessmentCubit() : super(AssessmentLoading());

  void fetchAssessments(int id) async {
    final result = await sl<GetAssessments>().call(param: id);

    result.fold(
      (error) {
        emit(LoadAssessmentFailure(errorMessage: error.message));
      },
      (data) {
        emit(AssessmentLoaded(assessments: data));
      },
    );
  }
}
