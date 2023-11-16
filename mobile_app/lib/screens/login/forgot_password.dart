import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';
import '../../authentication/auth.dart';
import 'error_message_widget.dart';
import 'login_form.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  String? errorMessage = '';

  Future<void> passwordReset() async {
    try {
      errorMessage = 'Password reset email has been sent';
      String? resetError =
          await Auth().passwordReset(email: _controllerEmail.text);
      if (resetError != null) {
        setState(() {
          errorMessage = resetError;
        });
      }
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  Widget _submitButton() {
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
      onPressed: () {
        passwordReset();
        FocusScope.of(context).unfocus();
      },
      child: const Text('Reset password'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color arrowColor = theme.brightness == Brightness.light
        ? AppColors.textLight
        : AppColors.textDark;
    final Color backgroundColor = theme.brightness == Brightness.light
        ? AppColors.backgroundLight
        : AppColors.backgroundDark;
    final Color iconColor = theme.brightness == Brightness.light
        ? AppColors.iconLight
        : AppColors.iconDark;
    final Color textColor = theme.brightness == Brightness.light
        ? AppColors.textLight
        : AppColors.textDark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: arrowColor),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        backgroundColor: backgroundColor,
        body: Container(
          color: backgroundColor,
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                const SizedBox(height: 40),
                LoginFormEntry('E-mail', _controllerEmail, Icons.person, false,
                    false, () {}, iconColor, textColor),
                const SizedBox(height: 10),
                ErrorMessageWidget(errorMessage ?? ''),
                const SizedBox(height: 10),
                _submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
