import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'admin/home_page/home_page.dart';
import 'login/verify_email.dart';
import 'login/login_page.dart';
import 'user/main_page.dart';
import '/constants/config.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;

          if (user != null) {
            String userEmailAddress =
                user.email ?? ""; // Fetch user's email address
            // Check if email is verified
            if (user.emailVerified) {
              if (userEmailAddress == adminEmail) {
                return const AdminHomePage();
              } else {
                return const MainPage();
              }
            } else {
              return const VerifyEmailPage();
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
