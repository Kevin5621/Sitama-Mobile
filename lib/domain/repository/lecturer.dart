import 'package:dio/dio.dart';
import 'package:Sitama/data/models/guidance.dart';
import 'package:Sitama/data/models/log_book.dart';
import 'package:Sitama/data/models/notification.dart';
import 'package:Sitama/domain/entities/industry_score.dart';
import 'package:dartz/dartz.dart';

abstract class ScoreRepository {
  Future<void> updateScores(List<IndustryScore> scores);
}

abstract class LecturerRepository {
  Future<Either> getLecturerHome();
  Future<Either> getDetailStudent(int id);

  Future<Either> updateStatusGuidance(UpdateStatusGuidanceReqParams request);
  Future<Either> updateLogBookNote(UpdateLogBookReqParams request);
  Future<Either<String, Response>> addNotification(AddNotificationReqParams request);

  Future<Either> fetchAssessments(int id);
  Future<Either<String, Response>> submitScores (int id, List<Map<String, dynamic>> scores);
  Future<Either> getLecturerProfile();
  Future<Either> updateFinishedStudent({required bool status,required int id});
}
