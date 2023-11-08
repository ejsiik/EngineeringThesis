import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String errorMessage;

  const ErrorMessageWidget(this.errorMessage, {super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color? accentColor = theme.textTheme.bodyLarge!.color;

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: Text(
        errorMessage.isEmpty ? '' : errorMessage,
        style: TextStyle(
          color: accentColor,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
