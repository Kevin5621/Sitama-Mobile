import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:sitama/features/lecturer/domain/entities/industry_score.dart';
import 'package:sitama/features/shared/data/models/guidance.dart';
import 'package:sitama/features/shared/data/models/log_book.dart';
import 'package:sitama/features/student/data/models/notification.dart';

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
