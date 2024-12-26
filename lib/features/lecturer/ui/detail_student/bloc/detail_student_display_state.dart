
import 'package:sitama/features/lecturer/domain/entities/lecturer_detail_student.dart';

abstract class DetailStudentDisplayState {}

class DetailLoading extends DetailStudentDisplayState {}

class DetailLoaded extends DetailStudentDisplayState {
  final DetailStudentEntity detailStudentEntity;
  final Map<int, bool> internshipApprovalStatus;
  final bool isOffline;

  DetailLoaded({
    required this.detailStudentEntity,
    Map<int, bool>? internshipApprovalStatus,
    this.isOffline = false,
  }) : internshipApprovalStatus = internshipApprovalStatus ?? {};

  DetailLoaded copyWith({
    DetailStudentEntity? detailStudentEntity,
    Map<int, bool>? internshipApprovalStatus,
    bool? isStarRounded,
    bool? isOffline,
  }) {
    return DetailLoaded(
      detailStudentEntity: detailStudentEntity ?? this.detailStudentEntity,
      internshipApprovalStatus: internshipApprovalStatus ?? this.internshipApprovalStatus,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

class DetailFailure extends DetailStudentDisplayState {
  final String errorMessage;
  final bool isOffline;
  final DetailStudentEntity? cachedData;

  DetailFailure({
    required this.errorMessage,
    this.isOffline = false,
    this.cachedData,
  });
}
