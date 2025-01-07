import 'dart:convert';
import 'package:sitama/features/lecturer/domain/entities/lecturer_profile_entity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
      // Cek Conectivty
      final connectivityResult = await Connectivity().checkConnectivity();
      final isOffline = connectivityResult == ConnectivityResult.none;

      // Try to load cached data
      final cachedJson = prefs.getString('cached_profile_data');
      
      if (cachedJson != null) {
        try {
          final Map<String, dynamic> jsonMap = json.decode(cachedJson);
          final cachedData = LecturerProfileEntity.fromJson(jsonMap);
          
          // If offline, use cache
          if (isOffline) {
            emit(LecturerLoaded(
              lecturerProfileEntity: cachedData,
              isOffline: true,
            ));
            return;
          }
        } catch (e) {
          await prefs.remove('cached_profile_data');
        }
      }

      if (!isOffline) {
        var result = await sl<GetProfileLecturerUseCase>().call();
        result.fold(
          (error) {
          // If error occurs, try to load cached data
            if (cachedJson != null) {
              try {
                final jsonMap = json.decode(cachedJson);
                final cachedData = LecturerProfileEntity.fromJson(jsonMap);
                emit(LoadLecturerFailure(
                  errorMessage: error,
                  isOffline: true,
                  cachedData: cachedData,
                ));
              } catch (e) {
                emit(LoadLecturerFailure(
                  errorMessage: error,
                  isOffline: isOffline,
                ));
              }
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
              isOffline: false,
            ));
          },
        );
      } else {
        emit(LoadLecturerFailure(
          errorMessage: 'Tidak ada Internet, tidak ada data yang tersimpan',
          isOffline: true,
        ));
      }
    } catch (e) {
      emit(LoadLecturerFailure(
        errorMessage: e.toString(),
        isOffline: false,
      ));
    }
  }
}