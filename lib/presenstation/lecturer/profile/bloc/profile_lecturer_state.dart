import 'package:sitama/domain/entities/lecturer_profile_entity.dart';

abstract class ProfileLecturerState {}

class LecturerLoading extends ProfileLecturerState {}

class LecturerLoaded extends ProfileLecturerState {
  final LecturerProfileEntity lecturerProfileEntity;
  final bool isOffline;

  LecturerLoaded({
    required this.lecturerProfileEntity,
    this.isOffline = false,
  });
}

class LoadLecturerFailure extends ProfileLecturerState {
  final String errorMessage;
  final bool isOffline;
  final LecturerProfileEntity? cachedData;

  LoadLecturerFailure({
    required this.errorMessage,
    this.isOffline = false,
    this.cachedData,
  });
}