import 'package:sistem_magang/domain/entities/industry_score.dart';
import 'package:sistem_magang/domain/repository/lecturer.dart';

class UpdateScoresUseCase {
  final ScoreRepository repository;

  UpdateScoresUseCase(this.repository);

  Future<void> execute(List<IndustryScore> scores) async {
    await repository.updateScores(scores);
  }
}
