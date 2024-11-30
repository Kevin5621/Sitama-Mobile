import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';

abstract class DetailStudentDisplayState {}

class DetailLoading extends DetailStudentDisplayState {}

class DetailLoaded extends DetailStudentDisplayState {
  final DetailStudentEntity detailStudentEntity;
  final bool isStarRounded;

  DetailLoaded({
    required this.detailStudentEntity,
    this.isStarRounded = false,
  });

  bool get isInternshipFinished => detailStudentEntity.is_finished ?? false;

  DetailLoaded copyWith({
    DetailStudentEntity? detailStudentEntity,
    bool? isStarRounded,
  }) {
    return DetailLoaded(
      detailStudentEntity: detailStudentEntity ?? this.detailStudentEntity,
      isStarRounded: isStarRounded ?? this.isStarRounded,
    );
  }

  bool isInternshipApproved(int index) => isInternshipFinished;
}

class DetailFailure extends DetailStudentDisplayState {
  final String errorMessage;

  DetailFailure({required this.errorMessage});
}