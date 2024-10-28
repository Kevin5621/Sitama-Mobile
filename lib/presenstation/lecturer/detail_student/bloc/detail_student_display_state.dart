import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';

abstract class DetailStudentDisplayState {}

class LecturerLoading extends DetailStudentDisplayState {}

class LecturerLoaded extends DetailStudentDisplayState {
  final DetailStudentEntity detailStudentEntity;
  final bool isChecked; // Status checkbox
  final bool isStarRounded; // Status bintang

  LecturerLoaded({
    required this.detailStudentEntity,
    this.isChecked = false, // Default tidak dicentang
    this.isStarRounded = false, // Default tidak terpilih
  });
}

class LoadLecturerFailure extends DetailStudentDisplayState {
  final String errorMessage;

  LoadLecturerFailure({required this.errorMessage});
}
