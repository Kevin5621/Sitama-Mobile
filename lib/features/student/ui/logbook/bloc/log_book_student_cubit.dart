import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/features/student/domain/usecases/logbook/get_log_book_student.dart';
import 'package:sitama/features/student/ui/logbook/bloc/log_book_student_state.dart';
import 'package:sitama/service_locator.dart';

class LogBookStudentCubit extends Cubit<LogBookStudentState> {
  LogBookStudentCubit() : super(LogBookLoading());

  Future<void> displayLogBook() async {
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
