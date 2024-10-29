import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';

abstract class DetailStudentDisplayState {}

class DetailLoading extends DetailStudentDisplayState {}

class DetailLoaded extends DetailStudentDisplayState {
  final DetailStudentEntity detailStudentEntity;
  final bool isChecked; // Status checkbox
  final bool isStarRounded; // Status bintang

  DetailLoaded({
    required this.detailStudentEntity,
    this.isChecked = false, // Default tidak dicentang
    this.isStarRounded = false, // Default tidak terpilih
  });
}

class DetailFailure extends DetailStudentDisplayState {
  final String errorMessage;

  DetailFailure({required this.errorMessage});
}
