import 'dart:convert';
import 'package:Sitama/domain/entities/lecturer_profile_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Sitama/domain/usecases/lecturer/get_profile_lecturer.dart';
import 'package:Sitama/presenstation/lecturer/profile/bloc/profile_lecturer_state.dart';
import 'package:Sitama/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileLecturerCubit extends Cubit<ProfileLecturerState> {
  final SharedPreferences prefs;
  
  ProfileLecturerCubit({
    required this.prefs,
  }) : super(LecturerLoading());

  void displayLecturer() async {
    try {
      // Get data from SharedPreferences
      final cachedJson = prefs.getString('cached_profile_data');
      if (cachedJson != null) {
        final cachedData = LecturerProfileEntity.fromJson(json.decode(cachedJson));
        emit(LecturerLoaded(lecturerProfileEntity: cachedData));
      } else {
        // If no cached data, make initial API call
        var result = await sl<GetProfileLecturerUseCase>().call();
        result.fold(
          (error) => emit(LoadLecturerFailure(errorMessage: error)),
          (data) async {
            await prefs.setString('cached_profile_data', json.encode(data.toJson()));
            emit(LecturerLoaded(lecturerProfileEntity: data));
          },
        );
      }
    } catch (e) {
      emit(LoadLecturerFailure(errorMessage: e.toString()));
    }
  }
}