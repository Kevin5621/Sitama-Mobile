import 'package:sitama/features/student/domain/entities/log_book_entity.dart';

abstract class LogBookStudentState {}

class LogBookLoading extends LogBookStudentState {}

class LogBookLoaded extends LogBookStudentState {
  final ListLogBookEntity logBookEntity;

  LogBookLoaded({required this.logBookEntity});
}

class LoadLogBookFailure extends LogBookStudentState {
  final String errorMessage;

  LoadLogBookFailure({required this.errorMessage});
}
