import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/domain/usecases/student/guidances/get_guidances_student.dart';
import 'package:sistem_magang/presenstation/student/guidance/bloc/guidance_student_state.dart';
import 'package:sistem_magang/service_locator.dart';

class GuidanceStudentCubit extends Cubit<GuidanceStudentState> {
  GuidanceStudentCubit() : super(GuidanceLoading());

  void displayGuidance() async {
    var resullt = await sl<GetGuidancesStudentUseCase>().call();
    resullt.fold(
      (error) {
        emit(LoadGuidanceFailure(errorMessage: error));
      },
      (data) {
        emit(GuidanceLoaded(guidanceEntity: data)); 
      },
    );
  }
}