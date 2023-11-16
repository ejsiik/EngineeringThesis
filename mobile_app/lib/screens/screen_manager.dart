import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login/verify_email.dart';
import 'login/login_page.dart';
import 'user/home_page.dart';

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
            // Check if email is verified
            if (user.emailVerified) {
              return const HomePage();
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
