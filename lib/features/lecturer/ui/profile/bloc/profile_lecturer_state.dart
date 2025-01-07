import 'package:sitama/features/lecturer/domain/entities/lecturer_profile_entity.dart';

abstract class ProfileLecturerState {}

class LecturerLoading extends ProfileLecturerState {}

class LecturerLoaded extends ProfileLecturerState {
  final LecturerProfileEntity lecturerProfileEntity;

  LecturerLoaded({required this.lecturerProfileEntity});
}

class LoadLecturerFailure extends ProfileLecturerState {
  final String errorMessage;

  LoadLecturerFailure({required this.errorMessage});
}