import 'package:flutter/material.dart';

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
          color: Colors.black,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
