import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import 'forgot_password.dart';

class ForgotPasswordButtonWidget extends StatelessWidget {
  const ForgotPasswordButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const ForgotPasswordPage();
            },
          ),
        );
        FocusScope.of(context).unfocus();
      },
      child: const Text(
        'Forgot Password?',
        style: TextStyle(
          color: AppColors.textDark,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
