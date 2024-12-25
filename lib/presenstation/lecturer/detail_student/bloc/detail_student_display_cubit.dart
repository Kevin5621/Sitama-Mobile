import 'dart:convert';
import 'package:Sitama/domain/entities/lecturer_detail_student.dart';
import 'package:Sitama/domain/repository/lecturer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Sitama/domain/usecases/lecturer/get_detail_student.dart';
import 'package:Sitama/presenstation/lecturer/detail_student/bloc/detail_student_display_state.dart';
import 'package:Sitama/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailStudentDisplayCubit extends Cubit<DetailStudentDisplayState> {
  final SharedPreferences prefs;
  static const int CACHE_DURATION_HOURS = 24;

  DetailStudentDisplayCubit({
    required this.prefs,
  }) : super(DetailLoading());

  bool isCacheValid(String cacheKey) {
    final timestamp = prefs.getString('${cacheKey}_timestamp');
    if (timestamp == null) return false;
    
    final cacheTime = DateTime.parse(timestamp);
    final now = DateTime.now();
    return now.difference(cacheTime).inHours < CACHE_DURATION_HOURS;
  }

  Future<void> cacheData(String key, dynamic data) async {
    await prefs.setString(key, json.encode(data));
    await prefs.setString('${key}_timestamp', DateTime.now().toIso8601String());
  }

  Future<void> saveOfflineAction(String action, Map<String, dynamic> data) async {
    final offlineActions = await getOfflineActions();
    offlineActions.add({
      'action': action,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    });
    await prefs.setString('offline_actions', json.encode(offlineActions));
  }

  Future<List<Map<String, dynamic>>> getOfflineActions() async {
    final actionsJson = prefs.getString('offline_actions');
    if (actionsJson == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(actionsJson));
  }

  Future<void> syncOfflineActions() async {
    final actions = await getOfflineActions();
    for (final action in actions) {
      try {
        switch (action['action']) {
          case 'submit_scores':
            await sl<LecturerRepository>().submitScores(
              action['data']['id'],
              action['data']['scores'],
            );
            break;
          case 'update_status':
            await sl<LecturerRepository>().updateFinishedStudent(
              id: action['data']['id'],
              status: action['data']['status'],
            );
            break;
        }
      } catch (e) {
        print('Error syncing action: ${action['action']} - ${e.toString()}');
        continue;
      }
    }
    await prefs.setString('offline_actions', json.encode([]));
  }

  Future<DetailStudentEntity?> getFromCache(int id) async {
    final cacheKey = 'cached_detail_student_$id';
    if (!isCacheValid(cacheKey)) return null;

    final cachedJson = prefs.getString(cacheKey);
    if (cachedJson == null) return null;

    return DetailStudentEntity.fromJson(json.decode(cachedJson));
  }

  void displayStudent(int id) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      final isOffline = connectivityResult == ConnectivityResult.none;

      if (isOffline) {
        final cachedData = await getFromCache(id);
        if (cachedData != null) {
          emit(DetailLoaded(
            detailStudentEntity: cachedData,
            isOffline: true,
          ));
          return;
        }
        emit(DetailFailure(
          errorMessage: 'No cached data available',
          isOffline: true,
        ));
        return;
      }

      await syncOfflineActions();

      var result = await sl<GetDetailStudentUseCase>().call(param: id);
      result.fold(
        (error) async {
          final cachedData = await getFromCache(id);
          emit(DetailFailure(
            errorMessage: error,
            isOffline: isOffline,
            cachedData: cachedData,
          ));
        },
        (data) async {
          await cacheData('cached_detail_student_$id', data.toJson());
          emit(DetailLoaded(
            detailStudentEntity: data,
            isOffline: isOffline,
          ));
        },
      );
    } catch (e) {
      final cachedData = await getFromCache(id);
      emit(DetailFailure(
        errorMessage: e.toString(),
        isOffline: true,
        cachedData: cachedData,
      ));
    }
  }

  Future<void> updateStudentStatus({
    required int id,
    required bool status,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final isOffline = connectivityResult == ConnectivityResult.none;

    if (isOffline) {
      await saveOfflineAction('update_status', {
        'id': id,
        'status': status,
      });
      
      final currentData = await getFromCache(id);
      if (currentData != null) {
        // Implement status update logic in cached data
        await cacheData('cached_detail_student_$id', currentData.toJson());
      }
      return;
    }

    try {
      final result = await sl<LecturerRepository>().updateFinishedStudent(
        id: id,
        status: status,
      );
      result.fold(
        (error) => emit(DetailFailure(errorMessage: error, isOffline: false)),
        (_) => displayStudent(id),
      );
    } catch (e) {
      emit(DetailFailure(
        errorMessage: e.toString(),
        isOffline: false,
      ));
    }
  }

    void toggleInternshipApproval(int index) {
    if (state is DetailLoaded) {
      final currentState = state as DetailLoaded;
      final newApprovalStatus = Map<int, bool>.from(currentState.internshipApprovalStatus);
      newApprovalStatus[index] = !(newApprovalStatus[index] ?? false);

      emit(currentState.copyWith(
        internshipApprovalStatus: newApprovalStatus,
      ));
    }
  }
}