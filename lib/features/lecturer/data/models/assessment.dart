
import 'package:sitama/features/lecturer/data/models/score.dart';
import 'package:sitama/features/lecturer/domain/entities/assessment_entity.dart';

class AssessmentModel {
  final String componentName;
  final List<ScoreModel> scores;

  AssessmentModel({required this.componentName, required this.scores});

  factory AssessmentModel.fromMap(Map<String, dynamic> map) {
    return AssessmentModel(
      componentName: map['component_name'] as String,
      scores: (map['scores'] as List)
          .map((item) => ScoreModel.fromMap(item))
          .toList(),
    );
  }

  AssessmentEntity toEntity() {
    return AssessmentEntity(
      componentName: componentName,
      scores: scores.map((score) => score.toEntity()).toList(),
    );
  }
}