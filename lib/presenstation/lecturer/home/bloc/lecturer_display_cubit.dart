import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Sitama/domain/entities/lecturer_home_entity.dart';
import 'package:Sitama/domain/usecases/lecturer/get_home_lecturer.dart';
import 'package:Sitama/presenstation/lecturer/home/bloc/lecturer_display_state.dart';
import 'package:Sitama/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:Sitama/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LecturerDisplayCubit extends Cubit<LecturerDisplayState> {
  final SelectionBloc selectionBloc;
  final SharedPreferences _prefs;
  LecturerHomeEntity? _cachedData;
  static const String CACHE_KEY = 'lecturer_home_data';

  LecturerDisplayCubit({
    required this.selectionBloc,
    required SharedPreferences prefs,
  }) : _prefs = prefs, super(LecturerLoading()) {
    selectionBloc.stream.listen((selectionState) {
      if (state is LecturerLoaded && !selectionState.isLocalOperation) {
        displayLecturer();
      }
    });
    _loadCachedData();
  }

  Future<void> _loadCachedData() async {
    final cachedJson = _prefs.getString(CACHE_KEY);
    if (cachedJson != null) {
      try {
        final Map<String, dynamic> jsonData = json.decode(cachedJson);
        _cachedData = LecturerHomeEntity(
          name: jsonData['name'],
          id: jsonData['id'],
          students: (jsonData['students'] as List?)
              ?.map((s) => LecturerStudentsEntity(
                  id: s['id'],
                  name: s['name'],
                  username: s['username'],
                  photo_profile: s['photo_profile'],
                  the_class: s['the_class'],
                  study_program: s['study_program'],
                  major: s['major'],
                  academic_year: s['academic_year'],
                  isFinished: s['isFinished'],
                  activities: Map<String, bool>.from(s['activities']),
                ))
              .toSet(),
          activities: Map<String, bool>.from(jsonData['activities'] ?? {}),
        );
        emit(LecturerLoaded(
          lecturerHomeEntity: _cachedData!,
          isOffline: true,
        ));
      } catch (e) {
        null;
      }
    }
  }

  Future<void> _cacheData(LecturerHomeEntity data) async {
    try {
      final jsonData = {
        'name': data.name,
        'id': data.id,
        'students': data.students?.map((s) => {
            'id': s.id,
            'name': s.name,
            'username': s.username,
            'photo_profile': s.photo_profile,
            'the_class': s.the_class,
            'study_program': s.study_program,
            'major': s.major,
            'academic_year': s.academic_year,
            'isFinished': s.isFinished,
            'activities': s.activities,
          }).toList(),
        'activities': data.activities,
      };
      await _prefs.setString(CACHE_KEY, json.encode(jsonData));
    } catch (e) {
      print('Error caching data: $e');
    }
  }

  Future<bool> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void displayLecturer() async {
    final bool isOnline = await _checkConnectivity();
    
    // If offline and we have cached data, show it
    if (!isOnline && _cachedData != null) {
      emit(LecturerLoaded(
        lecturerHomeEntity: _cachedData!,
        isOffline: true,
      ));
      return;
    }

    // If we're getting fresh data, only show loading if no cache
    if (_cachedData == null) {
      emit(LecturerLoading());
    }

    // Try to fetch fresh data
    try {
      var result = await sl<GetHomeLecturerUseCase>().call();
      result.fold(
        (error) {
          if (_cachedData != null) {
            // If error but we have cached data, show cached data
            emit(LoadLecturerFailure(
              errorMessage: error,
              isOffline: true,
              cachedData: _cachedData,
            ));
          } else {
            emit(LoadLecturerFailure(errorMessage: error));
          }
        },
        (data) {
          _cachedData = data;
          _cacheData(data);
          if (data.students != null) {
            emit(LecturerLoaded(lecturerHomeEntity: data));
          }
        },
      );
    } catch (e) {
      if (_cachedData != null) {
        emit(LecturerLoaded(
          lecturerHomeEntity: _cachedData!,
          isOffline: true,
        ));
      } else {
        emit(LoadLecturerFailure(
          errorMessage: 'Network error occurred',
          isOffline: true,
        ));
      }
    }
  }

  void updateLocalData(LecturerHomeEntity newData) {
    _cachedData = newData;
    _cacheData(newData);
    emit(LecturerLoaded(lecturerHomeEntity: newData));
  }
}