import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String errorMessage;
  const ErrorMessageWidget(this.errorMessage, {super.key});

  @override
  Widget build(BuildContext context) {
    const Color accentColor = AppColors.accent;

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: Text(
        errorMessage.isEmpty ? '' : errorMessage,
        style: const TextStyle(
          color: accentColor,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
