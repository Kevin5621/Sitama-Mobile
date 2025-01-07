import 'dart:convert';
import 'package:sitama/features/lecturer/data/models/lecturer_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/features/lecturer/domain/usecases/get_profile_lecturer.dart';
import 'package:sitama/features/lecturer/ui/profile/bloc/profile_lecturer_state.dart';
import 'package:sitama/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileLecturerCubit extends Cubit<ProfileLecturerState> {
  final SharedPreferences prefs;
  
  ProfileLecturerCubit({
    required this.prefs,
  }) : super(LecturerLoading());

  void displayLecturer() async {
    try {
      // Get cached data from SharedPreferences
      final cachedJson = prefs.getString('cached_lecturer_data');
      
      if (cachedJson != null) {
        final cachedData = LecturerProfileModel.fromMap(json.decode(cachedJson)).toEntity();

        emit(LecturerLoaded(lecturerProfileEntity: cachedData));
      } else {
        // If no cached data, make initial API call
        var result = await sl<GetProfileLecturerUseCase>().call();
        result.fold(
          (error) => emit(LoadLecturerFailure(errorMessage: error)),
          (data) async {
            // Cache the new data
            await prefs.setString('cached_lecturer_data', json.encode(data.toJson()));
            emit(LecturerLoaded(lecturerProfileEntity: data));
          },
        );
      }
    } catch (e) {
      emit(LoadLecturerFailure(errorMessage: e.toString()));
    }
  }
}