import 'package:flutter/material.dart';

class LoginFormEntry extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final IconData prefixIcon;
  final bool isPassword;
  final bool isPasswordVisible;
  final Function togglePasswordVisibility;

  const LoginFormEntry(this.title, this.controller, this.prefixIcon,
      this.isPassword, this.isPasswordVisible, this.togglePasswordVisibility,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color? textColor = isPassword
        ? theme.textTheme.bodyMedium!.color
        : theme.textTheme.bodyMedium!.color;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        style: TextStyle(color: textColor),
        obscureText: isPassword && !isPasswordVisible,
        decoration: InputDecoration(
          hintText: title,
          hintStyle: TextStyle(color: textColor),
          prefixIcon: Icon(prefixIcon, color: Colors.grey),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: textColor,
                  ),
                  onPressed: () {
                    // Toggle password visibility
                    togglePasswordVisibility();
                  },
                )
              : null,
        ),
      ),
    );
  }
}