import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_app/constants/text_strings.dart';
import 'package:mobile_app/screens/user/main_page.dart';
import '../../service/authentication/auth.dart';
import 'package:mobile_app/constants/colors.dart';

import '../../service/connection/connection_check.dart';

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

  // Helper method to safely call safeSetState
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

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
      bool isInternetConnected = await checkInternetConnectivity();
      if (!isInternetConnected) {
        safeSetState(() {
          errorMessage = connection;
        });
        return;
      }
      bool verified = await Auth().checkEmailVerified();
      safeSetState(() {
        isEmailVerified = verified;
      });
    } catch (error) {
      safeSetState(() {
        errorMessage = 'Błąd podczas sprawdzania statusu weryfikacji e-maila';
      });
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      bool isInternetConnected = await checkInternetConnectivity();
      if (!isInternetConnected) {
        safeSetState(() {
          errorMessage = connection;
        });
        return;
      }
      await Auth().sendVerificationEmail();

      safeSetState(() {
        canResendEmail = false;
      });

      await Future.delayed(const Duration(seconds: 30));

      safeSetState(() {
        canResendEmail = true;
      });

      // Check email verification status after sending the email
      await checkEmailVerification();
    } catch (error) {
      safeSetState(() {
        errorMessage = 'Błąd podczas wysyłania e-maila weryfikacyjnego';
      });
    }
  }

  Future<void> signOut() async {
    bool isInternetConnected = await checkInternetConnectivity();
    if (!isInternetConnected) {
      safeSetState(() {
        errorMessage = connection;
      });
      return;
    }
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
        ? const MainPage()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Zweryfikuj e-mail'),
              backgroundColor: backgroundColor,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'E-mail z linkiem weryfikacyjnym został wysłany',
                    style: TextStyle(color: textColor),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: canResendEmail ? sendVerificationEmail : null,
                    icon: const Icon(Icons.email, size: 32),
                    label: Text(
                      'Wyślij e-mail ponownie',
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
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: buttonBackgroundColor,
                    ),
                    child: Text(
                      'Anuluj',
                      style: TextStyle(color: buttonTextColor),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
