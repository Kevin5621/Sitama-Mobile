import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/features/lecturer/domain/entities/lecturer_home_entity.dart';
import 'package:sitama/features/lecturer/domain/usecases/get_home_lecturer.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/display/lecturer_display_state.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/selection/selection_bloc.dart';
import 'package:sitama/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LecturerDisplayCubit extends Cubit<LecturerDisplayState> {
  final SelectionBloc selectionBloc;
  final SharedPreferences _prefs;
  LecturerHomeEntity? _cachedData;
  static const String cacheKey = 'lecturer_home_data';

  LecturerDisplayCubit({
    required this.selectionBloc,
    required SharedPreferences prefs,
  }) : _prefs = prefs, super(LecturerLoading()) {
    selectionBloc.stream.listen((selectionState) {
      if (state is LecturerLoaded && !selectionState.isLocalOperation) {
        displayLecturer();
      }
    });
    // Immediately load cached data when cubit is created
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadCachedData();
    // After loading cache, try to fetch fresh data
    displayLecturer();
  }

  Future<void> _loadCachedData() async {
    final cachedJson = _prefs.getString(cacheKey);
    if (cachedJson != null) {
      try {
        final Map<String, dynamic> jsonData = json.decode(cachedJson);
        _cachedData = LecturerHomeEntity(
          name: jsonData['name'] ?? '',
          id: jsonData['id'] ?? '',
          students: (jsonData['students'] as List?)
              ?.map((s) => LecturerStudentsEntity(
                  id: s['id'] ?? 0,
                  user_id: s['user_id'] ?? '',
                  name: s['name'] ?? '',
                  username: s['username'] ?? '',
                  photo_profile: s['photo_profile'] ?? '',
                  the_class: s['the_class'] ?? '',
                  study_program: s['study_program'] ?? '',
                  major: s['major'] ?? '',
                  academic_year: s['academic_year'] ?? '',
                  isFinished: s['isFinished'] ?? false,
                  activities: Map<String, bool>.from(s['activities'] ?? {}),
                  hasNewLogbook: s['hasNewLogbook'] ?? false,
                  lastUpdated: s['lastUpdated'] != null 
                      ? DateTime.parse(s['lastUpdated'])
                      : null,
                ))
              .toSet(),
          activities: Map<String, bool>.from(jsonData['activities'] ?? {}),
        );
        
        if (_cachedData != null) {
          emit(LecturerLoaded(
            lecturerHomeEntity: _cachedData!,
            isOffline: true,
          ));
        }
      } catch (e) {
        // Log error but don't throw
        print('Error loading cached data: $e');
      }
    }
  }

  Future<void> displayLecturer() async {
    final bool isOnline = await _checkConnectivity();
    
    if (!isOnline) {
      if (_cachedData != null) {
        emit(LecturerLoaded(
          lecturerHomeEntity: _cachedData!,
          isOffline: true,
        ));
      } else {
        emit(LoadLecturerFailure(
          errorMessage: 'No cached data available',
          isOffline: true,
        ));
      }
      return;
    }

    try {
      var result = await sl<GetHomeLecturerUseCase>().call();
      result.fold(
        (error) {
          if (_cachedData != null) {
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
            'hasNewLogbook': s.hasNewLogbook,
            'lastUpdated': s.lastUpdated?.toIso8601String(),
          }).toList(),
        'activities': data.activities,
      };
      await _prefs.setString(cacheKey, json.encode(jsonData));
    // ignore: empty_catches
    } catch (e) {
    }
  }

  Future<bool> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void updateLocalData(LecturerHomeEntity newData) {
    _cachedData = newData;
    _cacheData(newData);
    emit(LecturerLoaded(lecturerHomeEntity: newData));
  }
}