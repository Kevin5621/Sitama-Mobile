import 'package:dartz/dartz.dart';
import 'package:sitama/features/shared/data/models/guidance.dart';
import 'package:sitama/features/shared/data/models/log_book.dart';
abstract class StudentRepository {
  Future<Either> getStudentHome();

  Future<Either> getGuidances();
  Future<Either> addGuidances(AddGuidanceReqParams request);
  Future<Either> editGuidances(EditGuidanceReqParams request);
  Future<Either> deleteGuidances(int id);

  Future<Either> getLogBook();
  Future<Either> addLogBook(AddLogBookReqParams request);
  Future<Either> editLogBook(EditLogBookReqParams request);
  Future<Either> deleteLogBook(int id);

  Future<Either> getNotifications();
  Future<Either> markAllNotificationsAsRead();

  Future<Either> getStudentProfile();
}