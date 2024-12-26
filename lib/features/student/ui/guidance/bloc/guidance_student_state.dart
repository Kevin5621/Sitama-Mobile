import 'package:sitama/features/student/domain/entities/guidance_entity.dart';

abstract class GuidanceStudentState {}

class GuidanceLoading extends GuidanceStudentState {}

class GuidanceLoaded extends GuidanceStudentState {
  final ListGuidanceEntity guidanceEntity;

  GuidanceLoaded({required this.guidanceEntity});
}

class LoadGuidanceFailure extends GuidanceStudentState {
  final String errorMessage;

  LoadGuidanceFailure({required this.errorMessage});
}