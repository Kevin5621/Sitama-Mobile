import 'package:get_it/get_it.dart';
import 'package:sistem_magang/core/network/dio_client.dart';
import 'package:sistem_magang/core/service/notification_handler_service.dart';
import 'package:sistem_magang/core/service/notification_service.dart';
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
import 'package:sistem_magang/domain/usecases/student/guidances/add_guidance_student.dart';
import 'package:sistem_magang/domain/usecases/student/logbook/add_log_book_student.dart';
import 'package:sistem_magang/domain/usecases/student/guidances/delete_guidance_student.dart';
import 'package:sistem_magang/domain/usecases/student/logbook/delete_log_book_student.dart';
import 'package:sistem_magang/domain/usecases/student/guidances/edit_guidance_student.dart';
import 'package:sistem_magang/domain/usecases/student/logbook/edit_log_book_student.dart';
import 'package:sistem_magang/domain/usecases/lecturer/get_detail_student.dart';
import 'package:sistem_magang/domain/usecases/student/guidances/get_guidances_student.dart';
import 'package:sistem_magang/domain/usecases/lecturer/get_home_lecturer.dart';
import 'package:sistem_magang/domain/usecases/student/general/get_home_student.dart';
import 'package:sistem_magang/domain/usecases/student/logbook/get_log_book_student.dart';
import 'package:sistem_magang/domain/usecases/lecturer/get_profile_lecturer.dart';
import 'package:sistem_magang/domain/usecases/student/general/get_profile_student.dart';
import 'package:sistem_magang/domain/usecases/general/is_logged_in.dart';
import 'package:sistem_magang/domain/usecases/general/log_out.dart';
import 'package:sistem_magang/domain/usecases/general/reset_password.dart';
import 'package:sistem_magang/domain/usecases/general/signin.dart';
import 'package:sistem_magang/domain/usecases/general/update_photo_profile.dart';
import 'package:sistem_magang/domain/usecases/lecturer/update_status_guidance.dart';
import 'package:sistem_magang/domain/usecases/student/notification/get_notification.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/domain/usecases/student/notification/mark_allnotifications.dart';


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

  //bloc
  sl.registerSingleton<SelectionBloc>(SelectionBloc());
  
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
  sl.registerSingleton<GetProfileLecturerUseCase>(GetProfileLecturerUseCase());

  sl.registerSingleton<GetHomeLecturerUseCase>(GetHomeLecturerUseCase());
  sl.registerSingleton<GetDetailStudentUseCase>(GetDetailStudentUseCase());
  sl.registerSingleton<UpdateStatusGuidanceUseCase>(UpdateStatusGuidanceUseCase());

  sl.registerSingleton<GetNotificationsUseCase>(GetNotificationsUseCase());
  sl.registerSingleton<MarkAllNotificationsReadUseCase>(MarkAllNotificationsReadUseCase());

  sl.registerSingleton<UpdatePhotoProfileUseCase>(UpdatePhotoProfileUseCase());
  sl.registerSingleton<ResetPasswordUseCase>(ResetPasswordUseCase());
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase());

  sl.registerLazySingleton<NotificationHandlerService>(() => NotificationHandlerService(
    notificationService: sl<NotificationService>(),
    studentApiService: sl<StudentApiService>(),
    lecturerApiService: sl<LecturerApiService>(),
  ));
  sl.registerLazySingleton<NotificationService>(() => NotificationService());
}