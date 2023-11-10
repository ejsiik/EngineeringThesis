import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';

class LoginOrRegisterButtonWidget extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onTap;

  const LoginOrRegisterButtonWidget(this.isLogin, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        isLogin
            ? 'Not a member? Register now'
            : 'Already have an account? Login',
        style: const TextStyle(
          color: AppColors.textDark,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
