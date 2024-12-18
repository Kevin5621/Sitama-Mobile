import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Sitama/data/models/score_request.dart';
import 'package:Sitama/domain/repository/lecturer.dart';
import 'package:Sitama/domain/usecases/lecturer/get_assessmet.dart';
import 'package:Sitama/presenstation/lecturer/input_score/bloc/assessment_state.dart';
import 'package:Sitama/service_locator.dart';

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
