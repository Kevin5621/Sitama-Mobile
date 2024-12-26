import 'package:sitama/presenstation/student/guidance/bloc/guidance_student_cubit.dart';
import 'package:sitama/presenstation/student/logbook/bloc/log_book_student_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:sitama/core/network/dio_client.dart';
import 'package:sitama/data/repository/auth.dart';
import 'package:sitama/data/repository/lecturer.dart';
import 'package:sitama/data/repository/student.dart';
import 'package:sitama/data/source/auth_api_service.dart';
import 'package:sitama/data/source/auth_local_service.dart';
import 'package:sitama/data/source/lecturer_api_service.dart';
import 'package:sitama/data/source/student_api_service.dart';
import 'package:sitama/domain/repository/auth.dart';
import 'package:sitama/domain/repository/lecturer.dart';
import 'package:sitama/domain/repository/student.dart';
import 'package:sitama/domain/usecases/lecturer/get_assessmet.dart';
import 'package:sitama/domain/usecases/lecturer/update_status_logbook.dart';
import 'package:sitama/domain/usecases/student/guidances/add_guidance_student.dart';
import 'package:sitama/domain/usecases/student/logbook/add_log_book_student.dart';
import 'package:sitama/domain/usecases/student/guidances/delete_guidance_student.dart';
import 'package:sitama/domain/usecases/student/logbook/delete_log_book_student.dart';
import 'package:sitama/domain/usecases/student/guidances/edit_guidance_student.dart';
import 'package:sitama/domain/usecases/student/logbook/edit_log_book_student.dart';
import 'package:sitama/domain/usecases/lecturer/get_detail_student.dart';
import 'package:sitama/domain/usecases/student/guidances/get_guidances_student.dart';
import 'package:sitama/domain/usecases/lecturer/get_home_lecturer.dart';
import 'package:sitama/domain/usecases/student/general/get_home_student.dart';
import 'package:sitama/domain/usecases/student/logbook/get_log_book_student.dart';
import 'package:sitama/domain/usecases/lecturer/get_profile_lecturer.dart';
import 'package:sitama/domain/usecases/student/general/get_profile_student.dart';
import 'package:sitama/domain/usecases/general/is_logged_in.dart';
import 'package:sitama/domain/usecases/general/log_out.dart';
import 'package:sitama/domain/usecases/general/reset_password.dart';
import 'package:sitama/domain/usecases/general/signin.dart';
import 'package:sitama/domain/usecases/general/update_photo_profile.dart';
import 'package:sitama/domain/usecases/lecturer/update_status_guidance.dart';
import 'package:sitama/domain/usecases/student/notification/add_notification.dart';
import 'package:sitama/domain/usecases/student/notification/get_notification.dart';
import 'package:sitama/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sitama/domain/usecases/student/notification/mark_all_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';


final sl = GetIt.instance;

void setupServiceLocator(SharedPreferences prefs) {
  sl.registerSingleton<SharedPreferences>(prefs);

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
  sl.registerLazySingleton(() => GuidanceStudentCubit());
  sl.registerLazySingleton(() => LogBookStudentCubit());
  
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
  sl.registerSingleton<UpdateLogBookNoteUseCase>(UpdateLogBookNoteUseCase());
  sl.registerSingleton<UpdateStatusGuidanceUseCase>(UpdateStatusGuidanceUseCase());
  sl.registerSingleton<AddNotificationsUseCase>(AddNotificationsUseCase());
  sl.registerSingleton<GetAssessments>(GetAssessments());

  sl.registerSingleton<GetNotificationsUseCase>(GetNotificationsUseCase());
  sl.registerSingleton<MarkAllNotificationsReadUseCase>(MarkAllNotificationsReadUseCase());

  sl.registerSingleton<UpdatePhotoProfileUseCase>(UpdatePhotoProfileUseCase());
  sl.registerSingleton<ResetPasswordUseCase>(ResetPasswordUseCase());
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase());
}