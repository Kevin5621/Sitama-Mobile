import 'package:sitama/domain/entities/industry_score.dart';
import 'package:sitama/domain/repository/lecturer.dart';

class UpdateScoresUseCase {
  final ScoreRepository repository;

  UpdateScoresUseCase(this.repository);

  Future<void> execute(List<IndustryScore> scores) async {
    await repository.updateScores(scores);
  }
}
