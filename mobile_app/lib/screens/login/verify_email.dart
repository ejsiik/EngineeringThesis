import 'dart:async';
import 'package:flutter/material.dart';
import '../user/home_page.dart';
import '../../authentication/auth.dart';
import 'package:mobile_app/constants/colors.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  String? errorMessage = '';
  Timer? timer;
  bool canResendEmail = false;

  @override
  void initState() {
    super.initState();
    checkEmailVerification();

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerification(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerification() async {
    try {
      bool verified = await Auth().checkEmailVerified();
      setState(() {
        isEmailVerified = verified;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Error checking email verification status: $error';
      });
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      await Auth().sendVerificationEmail();

      // Use the 'mounted' property to check if the widget is still in the widget tree
      if (mounted) {
        setState(() {
          canResendEmail = false;
        });
      }

      await Future.delayed(const Duration(seconds: 20));

      // Check 'mounted' again before updating the state
      if (mounted) {
        setState(() {
          canResendEmail = true;
        });
      }

      // Check email verification status after sending the email
      await checkEmailVerification();
    } catch (error) {
      if (mounted) {
        setState(() {
          errorMessage = 'Error sending verification email: $error';
        });
      }
    }
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.brightness == Brightness.light
        ? AppColors.backgroundLight
        : AppColors.backgroundDark;
    final Color textColor = theme.brightness == Brightness.light
        ? AppColors.textLight
        : AppColors.textDark;
    final Color buttonBackgroundColor = theme.brightness == Brightness.light
        ? AppColors.primaryLight
        : AppColors.primaryDark;
    final Color buttonTextColor = theme.brightness == Brightness.light
        ? AppColors.backgroundLight
        : AppColors.backgroundDark;

    return isEmailVerified
        ? const HomePage()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Verify email'),
              backgroundColor: backgroundColor,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Email link has been sent',
                    style: TextStyle(color: textColor),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: canResendEmail ? sendVerificationEmail : null,
                    icon: const Icon(Icons.email, size: 32),
                    label: Text(
                      'Resend email',
                      style: TextStyle(color: buttonTextColor),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonBackgroundColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      signOut();
                      //Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: buttonBackgroundColor,
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: buttonTextColor),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
