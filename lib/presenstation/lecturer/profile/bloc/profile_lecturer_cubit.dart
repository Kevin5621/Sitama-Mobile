import 'dart:convert';
import 'package:Sitama/domain/entities/lecturer_profile_entity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
      final connectivityResult = await Connectivity().checkConnectivity();
      final isOffline = connectivityResult == ConnectivityResult.none;

      if (isOffline) {
        // Try to load cached data
        final cachedJson = prefs.getString('cached_profile_data');
        if (cachedJson != null) {
          final cachedData = LecturerProfileEntity.fromJson(json.decode(cachedJson));
          emit(LecturerLoaded(
            lecturerProfileEntity: cachedData,
            isOffline: true,
          ));
          return;
        }
      }

      var result = await sl<GetProfileLecturerUseCase>().call();
      result.fold(
        (error) async {
          // If error occurs, try to load cached data
          final cachedJson = prefs.getString('cached_profile_data');
          if (cachedJson != null) {
            final cachedData = LecturerProfileEntity.fromJson(json.decode(cachedJson));
            emit(LoadLecturerFailure(
              errorMessage: error,
              isOffline: isOffline,
              cachedData: cachedData,
            ));
          } else {
            emit(LoadLecturerFailure(
              errorMessage: error,
              isOffline: isOffline,
            ));
          }
        },
        (data) async {
          // Cache the new data
          await prefs.setString('cached_profile_data', json.encode(data.toJson()));
          emit(LecturerLoaded(
            lecturerProfileEntity: data,
            isOffline: isOffline,
          ));
        },
      );
    } catch (e) {
      emit(LoadLecturerFailure(
        errorMessage: e.toString(),
        isOffline: false,
      ));
    }
  }
}
