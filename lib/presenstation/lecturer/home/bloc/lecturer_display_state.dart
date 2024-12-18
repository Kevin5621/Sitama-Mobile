import 'package:Sitama/domain/entities/lecturer_home_entity.dart';

abstract class LecturerDisplayState {}

class LecturerLoading extends LecturerDisplayState {}

class LecturerLoaded extends LecturerDisplayState {
  final LecturerHomeEntity lecturerHomeEntity;

  LecturerLoaded({required this.lecturerHomeEntity});
}

class LoadLecturerFailure extends LecturerDisplayState {
  final String errorMessage;

  LoadLecturerFailure({required this.errorMessage});
}