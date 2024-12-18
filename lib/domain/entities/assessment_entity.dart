import 'package:Sitama/domain/entities/score_entity.dart';

class AssessmentEntity {
  final String componentName;
  final List<ScoreEntity> scores;

  AssessmentEntity({required this.componentName, required this.scores});
}
