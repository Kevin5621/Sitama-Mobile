import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/core/config/assets/app_images.dart';
import 'package:sitama/features/auth/ui/bloc/auth_state.dart';
import 'package:sitama/features/auth/ui/bloc/auth_state_cubit.dart';
import 'package:sitama/features/auth/ui/pages/welcome.dart';
import 'package:sitama/features/lecturer/ui/home/pages/lecturer_home.dart';
import 'package:sitama/features/student/ui/home/pages/home.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
    if (!mounted) return;
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
