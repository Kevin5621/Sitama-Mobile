import 'package:sitama/features/lecturer/domain/entities/industry_score.dart';
import 'package:sitama/features/lecturer/domain/repositories/lecturer.dart';

class UpdateScoresUseCase {
  final ScoreRepository repository;

  UpdateScoresUseCase(this.repository);

  Future<void> execute(List<IndustryScore> scores) async {
    await repository.updateScores(scores);
  }
}
