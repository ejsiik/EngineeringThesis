import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_app/constants/theme.dart';
import 'package:mobile_app/firebase_options.dart';
import 'package:mobile_app/screens/screen_manager.dart';
//import 'package:mobile_app/service/notification/notification_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // initialization has been completed
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //await NotificationData().initNotifications();
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
      themeMode: ThemeMode.system,
      home: const WidgetTree(),
    );
  }
}
