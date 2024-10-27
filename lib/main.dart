import 'package:flutter/material.dart';
import 'package:sistem_magang/core/config/themes/app_theme.dart';
import 'package:sistem_magang/presenstation/general/splash/pages/splash.dart';
import 'package:sistem_magang/service_locator.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}