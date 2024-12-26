import 'package:dartz/dartz.dart';
import 'package:sitama/core/usecase/usecase.dart';
import 'package:sitama/data/models/notification.dart';
import 'package:sitama/domain/repository/lecturer.dart';
import 'package:sitama/service_locator.dart';

class AddNotificationsUseCase implements UseCase<Either, AddNotificationReqParams> {
  @override
  Future<Either> call({AddNotificationReqParams? param}) async {
    return sl<LecturerRepository>().addNotification(param!);
  }
}