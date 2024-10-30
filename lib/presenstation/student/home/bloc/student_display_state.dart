import 'package:sistem_magang/domain/entities/student_home_entity.dart';

abstract class StudentDisplayState {}

class StudentLoading extends StudentDisplayState{}
class StudentLoaded extends StudentDisplayState{
  final StudentHomeEntity studentHomeEntity;

  StudentLoaded({required this.studentHomeEntity});
}

class LoadStudentFailure extends StudentDisplayState{
  final String errorMessage;

  LoadStudentFailure({required this.errorMessage}); 
}