import 'package:sistem_magang/domain/entities/assessment_entity.dart';

abstract class AssessmentState {}

class AssessmentLoading extends AssessmentState {}

class AssessmentLoaded extends AssessmentState {
  final List<AssessmentEntity> assessments;

  AssessmentLoaded({required this.assessments});
}

class LoadAssessmentFailure extends AssessmentState {
  final String errorMessage;

  LoadAssessmentFailure({required this.errorMessage});
}
