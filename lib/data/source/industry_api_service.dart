// api_service.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_magang/core/constansts/api_urls.dart';
import 'package:sistem_magang/core/network/dio_client.dart';
import 'package:sistem_magang/data/models/industry_box_student.dart';
import 'package:sistem_magang/service_locator.dart';

abstract class IndustryApiService {
  Future<Either<String, InternshipModel>> getStudentProfile();
}

class IndustryApiServiceImpl implements IndustryApiService {
  @override
  Future<Either<String, InternshipModel>> getStudentProfile() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.get('token');

      var response = await sl<DioClient>().get(
        ApiUrls.studentHome,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null && data['internship'] != null) {
          return Right(InternshipModel.fromJson(data['internship']));
        }
        return const Left('Data not found');
      }

      return Left(
          response.data['errors']['message'] ?? 'Unknown error occurred');
    } on DioException catch (e) {
      return Left(
          e.response?.data['errors']['message'] ?? 'Error fetching profile');
    } catch (e) {
      return Left('Unexpected error occurred');
    }
  }
}
