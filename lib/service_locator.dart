import 'package:get_it/get_it.dart';
import 'package:sitama/core/network/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sitama/features/auth/data/repositories/auth.dart';
import 'package:sitama/features/auth/data/sources/auth_api_service.dart';
import 'package:sitama/features/auth/data/sources/auth_local_service.dart';
import 'package:sitama/features/auth/domain/repositories/auth.dart';
import 'package:sitama/features/auth/domain/usecases/is_logged_in.dart';
import 'package:sitama/features/auth/domain/usecases/log_out.dart';
import 'package:sitama/features/auth/domain/usecases/signin.dart';
import 'package:sitama/features/auth/domain/usecases/signin_google.dart';
import 'package:sitama/features/lecturer/data/repositories/lecturer.dart';
import 'package:sitama/features/lecturer/data/sources/lecturer_api_service.dart';
import 'package:sitama/features/lecturer/domain/repositories/lecturer.dart';
import 'package:sitama/features/lecturer/domain/usecases/get_assessmet.dart';
import 'package:sitama/features/lecturer/domain/usecases/get_detail_student.dart';
import 'package:sitama/features/lecturer/domain/usecases/get_home_lecturer.dart';
import 'package:sitama/features/lecturer/domain/usecases/get_profile_lecturer.dart';
import 'package:sitama/features/lecturer/domain/usecases/update_status_guidance.dart';
import 'package:sitama/features/lecturer/domain/usecases/update_status_logbook.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/selection/selection_bloc.dart';
import 'package:sitama/features/shared/domain/usecases/reset_password.dart';
import 'package:sitama/features/shared/domain/usecases/update_photo_profile.dart';
import 'package:sitama/features/student/data/repositories/student.dart';
import 'package:sitama/features/student/data/sources/student_api_service.dart';
import 'package:sitama/features/student/domain/repositories/student.dart';
import 'package:sitama/features/student/domain/usecases/general/get_home_student.dart';
import 'package:sitama/features/student/domain/usecases/general/get_profile_student.dart';
import 'package:sitama/features/student/domain/usecases/guidances/add_guidance_student.dart';
import 'package:sitama/features/student/domain/usecases/guidances/delete_guidance_student.dart';
import 'package:sitama/features/student/domain/usecases/guidances/edit_guidance_student.dart';
import 'package:sitama/features/student/domain/usecases/guidances/get_guidances_student.dart';
import 'package:sitama/features/student/domain/usecases/logbook/add_log_book_student.dart';
import 'package:sitama/features/student/domain/usecases/logbook/delete_log_book_student.dart';
import 'package:sitama/features/student/domain/usecases/logbook/edit_log_book_student.dart';
import 'package:sitama/features/student/domain/usecases/logbook/get_log_book_student.dart';
import 'package:sitama/features/student/domain/usecases/notification/add_notification.dart';
import 'package:sitama/features/student/domain/usecases/notification/get_notification.dart';
import 'package:sitama/features/student/domain/usecases/notification/mark_all_notifications.dart';
import 'package:sitama/features/student/ui/guidance/bloc/guidance_student_cubit.dart';
import 'package:sitama/features/student/ui/logbook/bloc/log_book_student_cubit.dart';


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
  sl.registerSingleton<SigninGoogleUseCase>(SigninGoogleUseCase());
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