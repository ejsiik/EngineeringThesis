import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'forgot_password.dart';

class ForgotPasswordButtonWidget extends StatelessWidget {
  const ForgotPasswordButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color textColor = theme.brightness == Brightness.light
        ? AppColors.textLight
        : AppColors.textDark;

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
      child: Text(
        'Zresetuj hasło',
        style: TextStyle(
          color: textColor,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
