import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';

abstract class DetailStudentDisplayState {}

class DetailLoading extends DetailStudentDisplayState {}

class DetailLoaded extends DetailStudentDisplayState {
  final DetailStudentEntity detailStudentEntity;
  final Map<int, bool> internshipApprovalStatus; // Menyimpan status approval untuk setiap internship
  final bool isStarRounded;

  DetailLoaded({
    required this.detailStudentEntity,
    Map<int, bool>? internshipApprovalStatus,
    this.isStarRounded = false,
  }) : internshipApprovalStatus = internshipApprovalStatus ?? {};

  // Helper method untuk mendapatkan status approval berdasarkan index
  bool isInternshipApproved(int index) {
    return internshipApprovalStatus[index] ?? false;
  }

  // Method untuk membuat salinan state dengan status approval yang diperbarui
  DetailLoaded copyWith({
    DetailStudentEntity? detailStudentEntity,
    Map<int, bool>? internshipApprovalStatus,
    bool? isStarRounded,
  }) {
    return DetailLoaded(
      detailStudentEntity: detailStudentEntity ?? this.detailStudentEntity,
      internshipApprovalStatus: internshipApprovalStatus ?? this.internshipApprovalStatus,
      isStarRounded: isStarRounded ?? this.isStarRounded,
    );
  }
}

class DetailFailure extends DetailStudentDisplayState {
  final String errorMessage;

  DetailFailure({required this.errorMessage});
}