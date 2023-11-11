import 'package:flutter/material.dart';

class LoginFormEntry extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final IconData prefixIcon;
  final bool isPassword;
  final bool isPasswordVisible;
  final Function togglePasswordVisibility;
  final Color iconColor; // Dodaj kolor ikony
  final Color textColor;

  const LoginFormEntry(
      this.title,
      this.controller,
      this.prefixIcon,
      this.isPassword,
      this.isPasswordVisible,
      this.togglePasswordVisibility,
      this.iconColor,
      this.textColor,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        style: TextStyle(color: textColor),
        obscureText: isPassword && !isPasswordVisible,
        decoration: InputDecoration(
          hintText: title,
          hintStyle: TextStyle(color: iconColor),
          prefixIcon: Icon(prefixIcon, color: iconColor),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: iconColor,
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
