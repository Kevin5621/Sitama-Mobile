import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:Sitama/core/provider/app_providers.dart';
import 'package:Sitama/core/config/themes/app_theme.dart';
import 'package:Sitama/core/config/themes/theme_provider.dart';
import 'package:Sitama/presenstation/general/splash/pages/splash.dart';
import 'package:Sitama/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  setupServiceLocator(prefs);
  
  runApp(
    MultiProvider(
      providers: AppProviders.providers,
      child: MultiBlocProvider(
        providers: AppProviders.blocProviders,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          navigatorKey: MyApp.navigatorKey,
          title: 'Sitama',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: const SplashPage(),
        );
      },
    );
  }
}