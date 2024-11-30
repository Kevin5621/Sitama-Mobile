import 'package:dartz/dartz.dart';
import 'package:sistem_magang/core/usecase/usecase.dart';
import 'package:sistem_magang/data/models/notification.dart';
import 'package:sistem_magang/domain/repository/student.dart';
import 'package:sistem_magang/service_locator.dart';

class MarkAllNotificationsReadUseCase implements UseCase<Either, MarkAllReqParams> {
  @override
  Future<Either> call({MarkAllReqParams? param}) async {
    return sl<StudentRepository>().markAllNotificationsAsRead();
  }
}
