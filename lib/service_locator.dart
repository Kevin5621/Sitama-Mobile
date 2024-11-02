import 'package:get_it/get_it.dart';
import 'package:sistem_magang/core/network/dio_client.dart';
import 'package:sistem_magang/data/repository/auth.dart';
import 'package:sistem_magang/data/repository/lecturer.dart';
import 'package:sistem_magang/data/repository/student.dart';
import 'package:sistem_magang/data/source/auth_api_service.dart';
import 'package:sistem_magang/data/source/auth_local_service.dart';
import 'package:sistem_magang/data/source/lecturer_api_service.dart';
import 'package:sistem_magang/data/source/student_api_service.dart';
import 'package:sistem_magang/domain/repository/auth.dart';
import 'package:sistem_magang/domain/repository/lecturer.dart';
import 'package:sistem_magang/domain/repository/student.dart';
import 'package:sistem_magang/domain/usecases/add_guidance_student.dart';
import 'package:sistem_magang/domain/usecases/add_log_book_student.dart';
import 'package:sistem_magang/domain/usecases/delete_guidance_student.dart';
import 'package:sistem_magang/domain/usecases/delete_log_book_student.dart';
import 'package:sistem_magang/domain/usecases/edit_guidance_student.dart';
import 'package:sistem_magang/domain/usecases/edit_log_book_student.dart';
import 'package:sistem_magang/domain/usecases/get_detail_student.dart';
import 'package:sistem_magang/domain/usecases/get_guidances_student.dart';
import 'package:sistem_magang/domain/usecases/get_home_lecturer.dart';
import 'package:sistem_magang/domain/usecases/get_home_student.dart';
import 'package:sistem_magang/domain/usecases/get_log_book_student.dart';
import 'package:sistem_magang/domain/usecases/get_profile_student.dart';
import 'package:sistem_magang/domain/usecases/is_logged_in.dart';
import 'package:sistem_magang/domain/usecases/log_out.dart';
import 'package:sistem_magang/domain/usecases/signin.dart';
import 'package:sistem_magang/domain/usecases/update_photo_profile.dart';
import 'package:sistem_magang/domain/usecases/update_status_guidance.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerSingleton<DioClient>(DioClient());

  //Service
  sl.registerSingleton<AuthApiService>(AuthApiServiceImpl());
  sl.registerSingleton<AuthLocalService>(AuthLocalServiceImpl());
  sl.registerSingleton<StudentApiService>(StudentApiServiceImpl());
  sl.registerSingleton<LecturerApiService>(LecturerApiServiceImpl());

  // Repostory
  sl.registerSingleton<AuthRepostory>(AuthRepostoryImpl());
  sl.registerSingleton<StudentRepository>(StudentRepositoryImpl());
  sl.registerSingleton<LecturerRepository>(LecturerRepositoryImpl());

  // Usecase
  sl.registerSingleton<SigninUseCase>(SigninUseCase());
  sl.registerSingleton<IsLoggedInUseCase>(IsLoggedInUseCase());
  sl.registerSingleton<GetHomeStudentUseCase>(GetHomeStudentUseCase());
  sl.registerSingleton<GetGuidancesStudentUseCase>(GetGuidancesStudentUseCase());
  sl.registerSingleton<AddGuidanceUseCase>(AddGuidanceUseCase());
  sl.registerSingleton<EditGuidanceUseCase>(EditGuidanceUseCase());
  sl.registerSingleton<DeleteGuidanceUseCase>(DeleteGuidanceUseCase());

  sl.registerSingleton<GetLogBookStudentUseCase>(GetLogBookStudentUseCase());
  sl.registerSingleton<AddLogBookUseCase>(AddLogBookUseCase());
  sl.registerSingleton<EditLogBookUseCase>(EditLogBookUseCase());
  sl.registerSingleton<DeleteLogBookUseCase>(DeleteLogBookUseCase());

  sl.registerSingleton<GetProfileStudentUseCase>(GetProfileStudentUseCase());

  sl.registerSingleton<GetHomeLecturerUseCase>(GetHomeLecturerUseCase());
  sl.registerSingleton<GetDetailStudentUseCase>(GetDetailStudentUseCase());
  sl.registerSingleton<UpdateStatusGuidanceUseCase>(UpdateStatusGuidanceUseCase());

  sl.registerSingleton<UpdatePhotoProfileUseCase>(UpdatePhotoProfileUseCase());
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase());
  // sl.registerLazySingleton(() => ProfileCubit(
  // apiClient: sl<SecureApiClient>(),
  // prefs: sl<SharedPreferences>(),
// ));
}