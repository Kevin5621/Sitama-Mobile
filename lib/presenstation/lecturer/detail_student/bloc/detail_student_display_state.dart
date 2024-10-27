import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';

abstract class DetailStudentDisplayState {}

class LecturerLoading extends DetailStudentDisplayState {}

class LecturerLoaded extends DetailStudentDisplayState {
  final DetailStudentEntity detailStudentEntity;

  LecturerLoaded({required this.detailStudentEntity});
}

class LoadLecturerFailure extends DetailStudentDisplayState {
  final String errorMessage;

  LoadLecturerFailure({required this.errorMessage});
}