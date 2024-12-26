import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sitama/core/config/themes/theme_provider.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/notification/notification_bloc.dart';
import 'package:sitama/features/lecturer/ui/input_score/bloc/assessment_cubit.dart';
import 'package:sitama/features/student/domain/usecases/notification/add_notification.dart';
import 'package:sitama/service_locator.dart';

class AppProviders {
  static List<SingleChildWidget> get providers => [
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
  ];

  static List<SingleChildWidget> get blocProviders => [
    BlocProvider(
      create: (context) => NotificationBloc(
        addNotificationsUseCase: sl<AddNotificationsUseCase>(),
      ),
    ),
    BlocProvider(
      create: (context) => AssessmentCubit(),
    ),
  ];
}