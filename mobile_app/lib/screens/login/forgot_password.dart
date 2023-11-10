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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.primaryDark,
        backgroundColor: AppColors.backgroundDark,
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
    //final ThemeData theme = Theme.of(context);
    const Color primaryColor = AppColors.primaryDark;
    const Color textColor = AppColors.textDark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: textColor),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        backgroundColor: primaryColor,
        body: Container(
          color: primaryColor,
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                const SizedBox(height: 80),
                LoginFormEntry(
                  'E-mail', _controllerEmail, Icons.person, false,
                  false, () {}, // Empty function as a placeholder
                ),
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
