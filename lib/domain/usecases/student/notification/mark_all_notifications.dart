import 'package:dartz/dartz.dart';
import 'package:Sitama/core/usecase/usecase.dart';
import 'package:Sitama/data/models/notification.dart';
import 'package:Sitama/domain/repository/student.dart';
import 'package:Sitama/service_locator.dart';

class MarkAllNotificationsReadUseCase implements UseCase<Either, MarkAllReqParams> {
  @override
  Future<Either> call({MarkAllReqParams? param}) async {
    return sl<StudentRepository>().markAllNotificationsAsRead();
  }
}
