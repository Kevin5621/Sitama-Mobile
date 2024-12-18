import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Sitama/domain/usecases/student/logbook/get_log_book_student.dart';
import 'package:Sitama/presenstation/student/logbook/bloc/log_book_student_state.dart';
import 'package:Sitama/service_locator.dart';

class LogBookStudentCubit extends Cubit<LogBookStudentState> {
  LogBookStudentCubit() : super(LogBookLoading());

  void displayLogBook() async {
    var resullt = await sl<GetLogBookStudentUseCase>().call();
    resullt.fold(
      (error) {
        emit(LoadLogBookFailure(errorMessage: error));
      },
      (data) {
        emit(LogBookLoaded(logBookEntity: data));
      },
    );
  }
}
