import 'package:flutter/material.dart';

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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // Dostosuj kolory tekstu i tła z motywu (Theme) aplikacji
        foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
        backgroundColor: Theme.of(context).primaryColor,
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
