import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:Sitama/data/models/guidance.dart';
import 'package:Sitama/data/models/log_book.dart';
import 'package:Sitama/data/models/notification.dart';
import 'package:Sitama/data/models/student_home.dart';
import 'package:Sitama/data/source/student_api_service.dart';
import 'package:Sitama/domain/repository/student.dart';
import 'package:Sitama/service_locator.dart';

class StudentRepositoryImpl extends StudentRepository {
  @override
  Future<Either> getStudentHome() async {
    Either result = await sl<StudentApiService>().getStudentHome();
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
          var dataModel = StudentHomeModel.fromMap(response.data['data']);
          var dataEntity = dataModel.toEntity();
          return Right(dataEntity);
        } catch (e) {
          return Left("Parsing error: $e");
        }
      },
    );
  }

  @override
  Future<Either> getGuidances() async {
    Either result = await sl<StudentApiService>().getGuidances();
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
          var dataModel = ListGuidanceModel.fromMap(response.data['data']);
          var dataEntity = dataModel.toEntity();
          return Right(dataEntity);
        } catch (e) {
          return Left("Parsing error: $e");
        }
      },
    );
  }

  @override
  Future<Either> addGuidances(AddGuidanceReqParams request) async {
    Either result = await sl<StudentApiService>().addGuidances(request);
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
  Future<Either> editGuidances(EditGuidanceReqParams request) async {
    Either result = await sl<StudentApiService>().editGuidances(request);
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
  Future<Either> deleteGuidances(int id) async {
    Either result = await sl<StudentApiService>().deleteGuidances(id);
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
  Future<Either> getLogBook() async {
    Either result = await sl<StudentApiService>().getLogBook();
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
          var dataModel = ListLogBookModel.fromMap(response.data['data']);
          var dataEntity = dataModel.toEntity();
          return Right(dataEntity);
        } catch (e) {
          return Left("Parsing error: $e");
        }
      },
    );
  }
  
  @override
  Future<Either> addLogBook(AddLogBookReqParams request) async {
    Either result = await sl<StudentApiService>().addLogBook(request);
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
  Future<Either> editLogBook(EditLogBookReqParams request) async {
    Either result = await sl<StudentApiService>().editLogBook(request);
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
  Future<Either> deleteLogBook(int id) async {
    Either result = await sl<StudentApiService>().deleteLogBook(id);
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
  Future<Either> getStudentProfile() async {
    Either result = await sl<StudentApiService>().getStudentProfile();
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
          var dataModel = StudentProfileModel.fromMap(response.data['data']);
          var dataEntity = dataModel.toEntity();
          return Right(dataEntity);
        } catch (e) {
          return Left("Parsing error: $e");
        }
      },
    );
  }
  
  @override
  Future<Either> getNotifications() async {
    Either result = await sl<StudentApiService>().getNotifications();
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
          var dataModel = NotificationDataModel.fromJson(response.data['data']);
          var dataEntity = dataModel.toEntity();
          return Right(dataEntity);
        } catch (e) {
          return Left("Parsing error: $e");
        }
      },
    );
  }

  @override
  Future<Either> markAllNotificationsAsRead() async {
    Either result = await sl<StudentApiService>().markAllNotificationsAsRead();
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }
}
  
