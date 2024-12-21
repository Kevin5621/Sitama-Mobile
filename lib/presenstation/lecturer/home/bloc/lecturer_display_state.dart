import 'package:Sitama/domain/entities/lecturer_home_entity.dart';

abstract class LecturerDisplayState {}

class LecturerLoading extends LecturerDisplayState {}

class LecturerLoaded extends LecturerDisplayState {
  final LecturerHomeEntity lecturerHomeEntity;
  final bool isOffline;

  LecturerLoaded({
    required this.lecturerHomeEntity,
    this.isOffline = false,
  });
}

class LoadLecturerFailure extends LecturerDisplayState {
  final String errorMessage;
  final bool isOffline;
  final LecturerHomeEntity? cachedData;

  LoadLecturerFailure({
    required this.errorMessage,
    this.isOffline = false,
    this.cachedData,
  });
}