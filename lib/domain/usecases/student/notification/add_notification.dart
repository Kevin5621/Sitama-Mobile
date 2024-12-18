import 'package:dartz/dartz.dart';
import 'package:Sitama/core/usecase/usecase.dart';
import 'package:Sitama/data/models/notification.dart';
import 'package:Sitama/domain/repository/lecturer.dart';
import 'package:Sitama/service_locator.dart';

class AddNotificationsUseCase implements UseCase<Either, AddNotificationReqParams> {
  @override
  Future<Either> call({AddNotificationReqParams? param}) async {
    return sl<LecturerRepository>().addNotification(param!);
  }
}