import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/features/student/domain/usecases/guidances/get_guidances_student.dart';
import 'package:sitama/features/student/ui/guidance/bloc/guidance_student_state.dart';
import 'package:sitama/service_locator.dart';

class GuidanceStudentCubit extends Cubit<GuidanceStudentState> {
  GuidanceStudentCubit() : super(GuidanceLoading());

  Future<void> displayGuidance() async {
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