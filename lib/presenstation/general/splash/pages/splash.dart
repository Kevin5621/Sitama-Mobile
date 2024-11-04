// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:sistem_magang/common/bloc/auth/auth_state.dart';
import 'package:sistem_magang/common/bloc/auth/auth_state_cubit.dart';
import 'package:sistem_magang/core/config/assets/app_images.dart';
import 'package:sistem_magang/presenstation/general/welcome/pages/welcome.dart';
import 'package:sistem_magang/presenstation/lecturer/home/pages/lecturer_home.dart';
import 'package:sistem_magang/presenstation/student/home/pages/home.dart';

// Future<void> requestNotificationPermissions() async {
//   if (Platform.isAndroid) {
//     final status = await Permission.notification.request();
//     if (status.isGranted) {
//       print('Notification permission granted');
//     } else if (status.isDenied) {
//       print('Notification permission denied');
//     }
//   }
// }


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppImages.pattern), fit: BoxFit.cover)),
        ),
        Center(
          child: Image.asset(
                AppImages.logo,
                width: 200,  
                height: 150, 
              ),
        ),
      ]),
    );
  }

  Future<void> redirect() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => BlocProvider(
          create: (context) => AuthStateCubit()..appStarted(),
          child:
              BlocBuilder<AuthStateCubit, AuthState>(builder: (context, state) {
            if (state is AuthenticatedStudent) {
              return HomePage();
            }
            if (state is AuthenticatedLecturer) {
              return LecturerHomePage();
            }
            if (state is UnAuthenticated) {
              return WelcomePages();
            }
            return Container();
          }),
        ),
      ),
    );
  }
}


