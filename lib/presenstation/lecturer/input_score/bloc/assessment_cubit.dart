import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/data/models/score_request.dart';
import 'package:sistem_magang/domain/repository/lecturer.dart';
import 'package:sistem_magang/domain/usecases/lecturer/get_assessmet.dart';
import 'package:sistem_magang/presenstation/lecturer/input_score/bloc/assessment_state.dart';
import 'package:sistem_magang/service_locator.dart';

class AssessmentCubit extends Cubit<AssessmentState> {
  final LecturerRepository _repository;
  AssessmentCubit() : _repository = sl<LecturerRepository>(),
  super(AssessmentLoading());

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

  Future<void> submitScores(int id, List<ScoreRequest> scores) async {
    final result = await _repository.submitScores(
      id,
      scores.map((e) => e.toMap()).toList(),
    );
    result.fold(
      (error) => emit(AssessmentSubmissionFailed(errorMessage: error)),
      (_) => emit(AssessmentSubmittedSuccess()),
    );
  }

}
