import 'package:flutter/material.dart';
import 'package:mobile_app/constants/theme.dart';
import 'screens/login/login_register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // System default theme mode (light/dark).
      home: const LoginPage(),
    );
  }
}
