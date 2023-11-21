import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';

class SubmitButtonWidget extends StatelessWidget {
  final bool isLogin;
  final TextEditingController controllerPassword;
  final TextEditingController controllerConfirmPassword;
  final VoidCallback onPressed;
  final VoidCallback togglePasswordVisibility;
  final VoidCallback signInWithEmailAndPassword;
  final VoidCallback handlePasswordMismatch;

  const SubmitButtonWidget(
      this.isLogin,
      this.controllerPassword,
      this.controllerConfirmPassword,
      this.onPressed,
      this.togglePasswordVisibility,
      this.signInWithEmailAndPassword,
      this.handlePasswordMismatch,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color buttonBackgroundColor = theme.brightness == Brightness.light
        ? AppColors.primaryLight
        : AppColors.primaryDark;
    final Color buttonTextColor = theme.brightness == Brightness.light
        ? AppColors.backgroundLight
        : AppColors.backgroundDark;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: buttonTextColor,
        backgroundColor: buttonBackgroundColor,
      ),
      onPressed: isLogin
          ? signInWithEmailAndPassword
          : () {
              if (controllerPassword.text.trim() ==
                  controllerConfirmPassword.text.trim()) {
                onPressed();
              } else {
                // Obsłuż brak dopasowania hasła
                handlePasswordMismatch();
              }
              FocusScope.of(context).unfocus();
            },
      child: Text(isLogin ? 'LOGIN' : 'REGISTER'),
    );
  }
}
