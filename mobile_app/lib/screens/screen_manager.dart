import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/screens/admin/navigation_page.dart';
import 'login/verify_email.dart';
import 'login/login_page.dart';
import 'user/main_page.dart';
import '/constants/config.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

bool isEmailAdmin(String email) {
  return adminEmail.contains(email);
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Error: ${snapshot.error}");
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data != null) {
            User? user = snapshot.data;

            if (user != null) {
              print('Użytkownik jest zalogowany');
              String userEmailAddress =
                  user.email ?? ""; // Fetch user's email address
              // Check if email is verified
              if (user.emailVerified) {
                if (isEmailAdmin(userEmailAddress)) {
                  return NavigationPage();
                } else {
                  return const MainPage();
                }
              } else {
                return const VerifyEmailPage();
              }
            } else {
              print('Użytkownik jest obecnie wylogowany');
              return const LoginPage();
            }
          } else {
            return const LoginPage();
          }
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
