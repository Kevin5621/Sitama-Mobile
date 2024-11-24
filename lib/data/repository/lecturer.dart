import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sistem_magang/data/models/assessment.dart';
import 'package:sistem_magang/data/models/guidance.dart';
import 'package:sistem_magang/data/models/lecturer_detail_student.dart';
import 'package:sistem_magang/data/models/lecturer_home.dart';
import 'package:sistem_magang/data/models/lecturer_profile.dart';
import 'package:sistem_magang/data/source/lecturer_api_service.dart';
import 'package:sistem_magang/domain/repository/lecturer.dart';
import 'package:sistem_magang/service_locator.dart';

class LecturerRepositoryImpl extends LecturerRepository{
  @override
  Future<Either> getLecturerHome() async {
    Either result = await sl<LecturerApiService>().getLecturerHome();
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        Response response = data;

        if (response.data['data'] == null ||
            response.data['data'] is! Map<String, dynamic>) {
          return Left("Invalid data format");
        }

        try {
          var dataModel = LecturerHomeModel.fromMap(response.data['data']);
          var dataEntity = dataModel.toEntity();
          return Right(dataEntity);
        } catch (e) {
          return Left("Parsing error: $e");
        }
      },
    );
  }
  
  @override
  Future<Either> getDetailStudent(int id) async {
    Either result = await sl<LecturerApiService>().getDetailStudent(id);
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        Response response = data;

        if (response.data['data'] == null ||
            response.data['data'] is! Map<String, dynamic>) {
          return Left("Invalid data format");
        }

        try {
          var dataModel = DetailStudentModel.fromMap(response.data['data']);
          var dataEntity = dataModel.toEntity();
          return Right(dataEntity);
        } catch (e) {
          return Left("Parsing error: $e");
        }
      },
    );
  }
  
  @override
  Future<Either> updateStatusGuidance(UpdateStatusGuidanceReqParams request) async {
    Either result = await sl<LecturerApiService>().updateStatusGuidance(request);
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }
  
  @override
  Future<Either> getLecturerProfile() async {
    Either result = await sl<LecturerApiService>().getLecturerProfile();
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        Response response = data;

        // Check if 'data' is not null and is a Map
        if (response.data['data'] == null ||
            response.data['data'] is! Map<String, dynamic>) {
          return Left("Invalid data format");
        }

        try {
          var dataModel = LecturerProfileModel.fromMap(response.data['data']);
          var dataEntity = dataModel.toEntity();
          return Right(dataEntity);
        } catch (e) {
          return Left("Parsing error: $e");
        }
      },
    );
  }
  
  @override
  Future<Either> fetchAssessments(int id) async {
    Either result = await sl<LecturerApiService>().fetchAssessments(id);
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        Response response = data;

        try {
          final data = (response.data['data'] as List)
              .map((item) => AssessmentModel.fromMap(item).toEntity())
              .toList();
          return Right(data);
        } catch (e) {
          return Left("Parsing error: $e");
        }
      },
    );
  }
}