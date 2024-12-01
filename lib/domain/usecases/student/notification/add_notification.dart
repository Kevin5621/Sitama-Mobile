import 'package:dartz/dartz.dart';
import 'package:sistem_magang/core/usecase/usecase.dart';
import 'package:sistem_magang/data/models/notification.dart';
import 'package:sistem_magang/domain/repository/lecturer.dart';
import 'package:sistem_magang/service_locator.dart';

class AddNotificationsUseCase implements UseCase<Either, AddNotificationReqParams> {
  @override
  Future<Either> call({AddNotificationReqParams? param}) async {
    return sl<LecturerRepository>().addNotification(param!);
  }
}