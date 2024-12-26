import 'package:dartz/dartz.dart';
import 'package:sitama/features/lecturer/domain/repositories/lecturer.dart';
import 'package:sitama/features/student/data/models/notification.dart';
import 'package:sitama/service_locator.dart';
import 'package:sitama/utils/usecase.dart';

class AddNotificationsUseCase implements UseCase<Either, AddNotificationReqParams> {
  @override
  Future<Either> call({AddNotificationReqParams? param}) async {
    return sl<LecturerRepository>().addNotification(param!);
  }
}