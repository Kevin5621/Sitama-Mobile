import 'dart:convert';

import 'package:sitama/domain/entities/student_home_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/domain/usecases/student/general/get_profile_student.dart';
import 'package:sitama/presenstation/student/profile/bloc/profile_student_state.dart';
import 'package:sitama/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileStudentCubit extends Cubit<ProfileStudentState> {
  final SharedPreferences prefs;
  
  ProfileStudentCubit({
    required this.prefs,
  }) : super(StudentLoading());

  void displayStudent() async {
    try {
      // Get cached data from SharedPreferences
      final cachedJson = prefs.getString('cached_student_data');
      
      if (cachedJson != null) {
        final cachedData = StudentProfileEntity.fromJson(json.decode(cachedJson));
        emit(StudentLoaded(studentProfileEntity: cachedData));
      } else {
        // If no cached data, make initial API call
        var result = await sl<GetProfileStudentUseCase>().call();
        result.fold(
          (error) => emit(LoadStudentFailure(errorMessage: error)),
          (data) async {
            // Cache the new data
            await prefs.setString('cached_student_data', json.encode(data.toJson()));
            emit(StudentLoaded(studentProfileEntity: data));
          },
        );
      }
    } catch (e) {
      emit(LoadStudentFailure(errorMessage: e.toString()));
    }
  }
}
