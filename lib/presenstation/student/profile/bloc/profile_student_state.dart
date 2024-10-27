import 'package:sistem_magang/domain/entities/student_home_entity.dart';

abstract class ProfileStudentState {}

class StudentLoading extends ProfileStudentState {}

class StudentLoaded extends ProfileStudentState {
  final StudentProfileEntity studentProfileEntity;

  StudentLoaded({required this.studentProfileEntity});
}

class LoadStudentFailure extends ProfileStudentState {
  final String errorMessage;

  LoadStudentFailure({required this.errorMessage});
}