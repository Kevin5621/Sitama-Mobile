import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_magang/core/constansts/api_urls.dart';
import 'package:sistem_magang/core/network/dio_client.dart';
import 'package:sistem_magang/data/models/guidance.dart';
import 'package:sistem_magang/data/models/log_book.dart';
import 'package:sistem_magang/data/models/notification.dart';
import 'package:sistem_magang/service_locator.dart';

abstract class StudentApiService {
  Future<Either> getStudentHome();
  Future<Either> getGuidances();
  Future<Either> addGuidances(AddGuidanceReqParams request);
  Future<Either> editGuidances(EditGuidanceReqParams request);
  Future<Either> deleteGuidances(int id);

  Future<Either> getLogBook();
  Future<Either> addLogBook(AddLogBookReqParams request);
  Future<Either> editLogBook(EditLogBookReqParams request);
  Future<Either> deleteLogBook(int id);
  
  Future<Either> getNotifications();
  Future<Either> markAllNotificationsAsRead(MarkAllReqParams request);

  Future<Either> getStudentProfile();
}

class StudentApiServiceImpl extends StudentApiService {
  @override
  Future<Either> getStudentHome() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      var response = await sl<DioClient>().get(ApiUrls.studentHome,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      return Right(response);
    } on DioException catch (e) {
      return Left(e.response!.data['errors']['message']);
    }
  }

  @override
  Future<Either> getGuidances() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      var response = await sl<DioClient>().get(ApiUrls.studentGuidance,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      return Right(response);
    } on DioException catch (e) {
      return Left(e.response!.data['errors']['message']);
    }
  }

  @override
  Future<Either> addGuidances(AddGuidanceReqParams request) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      final formData = await request.toFormData();

      var response = await sl<DioClient>().post(
        ApiUrls.studentGuidance,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        data: formData,
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
  Future<Either> editGuidances(EditGuidanceReqParams request) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      final formData = await request.toFormData();
      formData.fields.add(MapEntry('_method', 'PUT'));

      var response = await sl<DioClient>().post(
        "${ApiUrls.studentGuidance}/${request.id}",
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        }),
        data: formData,
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
  Future<Either> deleteGuidances(int id) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      var response = await sl<DioClient>().delete(
        "${ApiUrls.studentGuidance}/$id",
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
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
  Future<Either> getLogBook() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      var response = await sl<DioClient>().get(ApiUrls.studentLogBook,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      return Right(response);
    } on DioException catch (e) {
      return Left(e.response!.data['errors']['message']);
    }
  }

  @override
  Future<Either> addLogBook(AddLogBookReqParams request) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      var response = await sl<DioClient>().post(
        ApiUrls.studentLogBook,
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
  Future<Either> editLogBook(EditLogBookReqParams request) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      var response = await sl<DioClient>().put(
        "${ApiUrls.studentLogBook}/${request.id}",
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
  Future<Either> deleteLogBook(int id) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      var response = await sl<DioClient>().delete(
        "${ApiUrls.studentLogBook}/$id",
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
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
  Future<Either> getStudentProfile() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      var response = await sl<DioClient>().get(ApiUrls.studentProfile,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      return Right(response);
    } on DioException catch (e) {
      return Left(e.response!.data['errors']['message']);
    }
  }
  
  @override
  Future<Either> getNotifications() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      var response = await sl<DioClient>().get(ApiUrls.notification,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      return Right(response);
    } on DioException catch (e) {
      return Left(e.response!.data['errors']['message']);
    }
  }

  @override
  Future<Either> markAllNotificationsAsRead(MarkAllReqParams request) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      var response = await sl<DioClient>().post(
        "${ApiUrls.notification}/mark-all", 
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: request.toJson(), 
      );

      return Right(response);
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(e.response!.data['errors'].toString());
      } else {
        return Left(e.message ?? 'An error occurred');
      }
    }
  }
}