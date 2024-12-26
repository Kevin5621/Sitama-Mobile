import 'package:dartz/dartz.dart';
import 'package:sitama/core/usecase/usecase.dart';
import 'package:sitama/data/models/notification.dart';
import 'package:sitama/domain/repository/student.dart';
import 'package:sitama/service_locator.dart';

class MarkAllNotificationsReadUseCase implements UseCase<Either, MarkAllReqParams> {
  @override
  Future<Either> call({MarkAllReqParams? param}) async {
    return sl<StudentRepository>().markAllNotificationsAsRead();
  }
}
