import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';

class LoginOrRegisterButtonWidget extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onTap;
  const LoginOrRegisterButtonWidget(this.isLogin, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color textColor = theme.brightness == Brightness.light
        ? AppColors.textLight
        : AppColors.textDark;

    return GestureDetector(
      onTap: onTap,
      child: Text(
        isLogin
            ? 'Not a member? Register now'
            : 'Already have an account? Login',
        style: TextStyle(
          color: textColor,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
