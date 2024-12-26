import 'package:sitama/domain/entities/student_home_entity.dart';
import 'package:sitama/data/models/notification.dart';

abstract class StudentDisplayState {}

class StudentLoading extends StudentDisplayState{}

class StudentLoaded extends StudentDisplayState {
  final StudentHomeEntity studentHomeEntity;
  final NotificationDataEntity? notifications;  

  StudentLoaded({
    required this.studentHomeEntity,
    this.notifications,
  });
}

class LoadStudentFailure extends StudentDisplayState {
  final String errorMessage;

  LoadStudentFailure({required this.errorMessage}); 
}