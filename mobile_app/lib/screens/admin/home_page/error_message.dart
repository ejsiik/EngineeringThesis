import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';

class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      message.isEmpty ? '' : 'Hmm? $message',
      style: const TextStyle(
        color: AppColors.accent,
        decoration: TextDecoration.underline,
      ),
    );
  }
}
