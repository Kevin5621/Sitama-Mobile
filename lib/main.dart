import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_magang/core/config/themes/app_theme.dart';
import 'package:sistem_magang/core/config/themes/theme_provider.dart';
import 'package:sistem_magang/presenstation/general/splash/pages/splash.dart';
import 'package:sistem_magang/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
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
          title: 'Sistem Magang',
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