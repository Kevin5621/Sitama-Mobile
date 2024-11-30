import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_magang/core/constansts/api_urls.dart';
import 'package:sistem_magang/core/network/dio_client.dart';
import 'package:sistem_magang/data/models/guidance.dart';
import 'package:sistem_magang/data/models/score_request.dart';
import 'package:sistem_magang/data/models/log_book.dart';
import 'package:sistem_magang/service_locator.dart';

abstract class LecturerApiService {
  Future<Either> getLecturerHome();
  Future<Either> getDetailStudent(int id);
  Future<Either> updateStatusGuidance(UpdateStatusGuidanceReqParams request);
  Future<Either> updateLogBookNote(UpdateLogBookReqParams request);
  Future<Either> getLecturerProfile();
  Future<Either> fetchAssessments(int id);
  Future<Either<String, Response>> submitScores(
      int id, List<Map<String, dynamic>> scores);
  Future<Either> updateFinishedStudent(bool status, int id);
}

class LecturerApiServiceImpl extends LecturerApiService {
  @override
  Future<Either> getLecturerHome() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      var response = await sl<DioClient>().get(ApiUrls.lecturerHome,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      return Right(response);
    } on DioException catch (e) {
      return Left(e.response!.data['errors']['message']);
    }
  }

  @override
  Future<Either> getDetailStudent(int id) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      var response = await sl<DioClient>().get("${ApiUrls.detailStudent}/$id",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      return Right(response);
    } on DioException catch (e) {
      return Left(e.response!.data['errors']['message']);
    }
  }

  @override
  Future<Either> updateStatusGuidance(
      UpdateStatusGuidanceReqParams request) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      var response = await sl<DioClient>().put(
        "${ApiUrls.updateStatusGuidance}/${request.id}",
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        data: request.toMap(),
      );

      return Right(response);
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(e.response!.data['errors'].toString());
      } else {
        return Left(e.message);
      }
    }
  }

  @override
  Future<Either> updateLogBookNote(UpdateLogBookReqParams request) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      var response = await sl<DioClient>().put(
        "${ApiUrls.updateLogBookNote}/${request.id}",
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        data: request.toMap(),
      );

      return Right(response);
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(e.response!.data['errors'].toString());
      } else {
        return Left(e.message);
      }
    }
  }

  @override
  Future<Either> getLecturerProfile() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      var response = await sl<DioClient>().get(
        ApiUrls.updateStatusProfile,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(e.response!.data['errors']['message']);
    }
  }

  @override
  Future<Either> fetchAssessments(int id) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      final response = await sl<DioClient>().get(
        '${ApiUrls.getAssessments}/$id',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      return Right(response);
    } on DioException catch (e) {
      return Left(e.response!.data['errors']['message']);
    }
  }

  @override
  Future<Either<String, Response>> submitScores(
      int id, List<Map<String, dynamic>> scores) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.getString('token');
      print(scores);

      var response = await Dio().post(
        "${ApiUrls.submitScores}/$id",
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
        data: {
          "scores": scores,
        },
      );
      print(response);
      return Right(response);
    } on DioException catch (e) {
      print(e.response!.data['errors']?.toString());
      if (e.response != null) {
        return Left(e.response!.data['errors']?.toString() ?? 'Unknown error');
      } else {
        return Left(e.message ?? 'Connection error');
      }
    }
  }

  @override
  Future<Either> updateFinishedStudent(bool status, int id) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      var response = await sl<DioClient>().put(
        "${ApiUrls.finishedStudent}/$id",
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        data: {"is_finished": status},
      );

      return Right(response);
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(e.response!.data['errors'].toString());
      } else {
        return Left(e.message);
      }
    }
  }
}
