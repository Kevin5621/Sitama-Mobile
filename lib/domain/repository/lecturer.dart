import 'package:sistem_magang/data/models/guidance.dart';
import 'package:sistem_magang/domain/entities/industry_score.dart';
import 'package:dartz/dartz.dart';

abstract class ScoreRepository {
  Future<void> updateScores(List<IndustryScore> scores);
}

abstract class LecturerRepository {
  Future<Either> getLecturerHome();
  Future<Either> getDetailStudent(int id);
  Future<Either> updateStatusGuidance(UpdateStatusGuidanceReqParams request);
  
  Future<Either> getLecturerProfile();
}
