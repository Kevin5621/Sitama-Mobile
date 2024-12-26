import 'package:dartz/dartz.dart';
import 'package:sitama/features/student/data/models/notification.dart';
import 'package:sitama/features/student/domain/repositories/student.dart';
import 'package:sitama/service_locator.dart';
import 'package:sitama/utils/usecase.dart';

class MarkAllNotificationsReadUseCase implements UseCase<Either, MarkAllReqParams> {
  @override
  Future<Either> call({MarkAllReqParams? param}) async {
    return sl<StudentRepository>().markAllNotificationsAsRead();
  }
}
