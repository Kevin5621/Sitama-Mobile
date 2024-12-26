import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/domain/usecases/student/general/get_home_student.dart';
import 'package:sitama/domain/usecases/student/notification/get_notification.dart';
import 'package:sitama/presenstation/student/home/bloc/student_display_state.dart';
import 'package:sitama/service_locator.dart';

class StudentDisplayCubit extends Cubit<StudentDisplayState> {
  StudentDisplayCubit() : super(StudentLoading());

  void displayStudent() async {
    try {
      // Load student data
      var studentResult = await sl<GetHomeStudentUseCase>().call();
      
      studentResult.fold(
        (error) {
          emit(LoadStudentFailure(errorMessage: error));
        },
        (studentData) async {
          var notificationResult = await sl<GetNotificationsUseCase>().call();
          
          notificationResult.fold(
            (error) {
              emit(StudentLoaded(
                studentHomeEntity: studentData,
                notifications: null,
              ));
            },
            (notificationData) {
              emit(StudentLoaded(
                studentHomeEntity: studentData,
                notifications: notificationData,
              ));
            },
          );
        },
      );
    } catch (e) {
      emit(LoadStudentFailure(errorMessage: e.toString()));
    }
  }
}