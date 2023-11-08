import 'package:flutter/material.dart';
import '../../authentication/auth.dart';
import 'login_form.dart';
import 'error_message_widget.dart';
import 'submit_button_widget.dart';
import 'login_or_register_button_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  final _controllerName = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _controllerConfirmPassword = TextEditingController();

  void handlePasswordMismatch() {
    setState(() {
      errorMessage = 'Passwords do not match';
    });
  }

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void toggleLoginRegister() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  Future<void> signInWithEmailAndPassword() async {
    await Auth().signInWithEmailAndPassword(
      email: _controllerEmail.text.trim(),
      password: _controllerPassword.text.trim(),
    );
  }

  Future<void> createUserWithEmailAndPassword() async {
    await Auth().createUserWithEmailAndPassword(
      email: _controllerEmail.text.trim(),
      password: _controllerPassword.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        color: primaryColor,
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              const SizedBox(height: 80),
              if (!isLogin)
                LoginFormEntry('Name', _controllerName, Icons.badge, false,
                    isPasswordVisible, togglePasswordVisibility),
              const SizedBox(height: 10),
              LoginFormEntry('E-mail', _controllerEmail, Icons.person, false,
                  isPasswordVisible, togglePasswordVisibility),
              const SizedBox(height: 10),
              LoginFormEntry('Password', _controllerPassword, Icons.lock, true,
                  isPasswordVisible, togglePasswordVisibility),
              const SizedBox(height: 10),
              if (!isLogin)
                LoginFormEntry(
                    'Confirm password',
                    _controllerConfirmPassword,
                    Icons.lock,
                    true,
                    isPasswordVisible,
                    togglePasswordVisibility),
              const SizedBox(height: 30),
              ErrorMessageWidget(errorMessage ?? ''),
              SubmitButtonWidget(
                  isLogin,
                  _controllerPassword,
                  _controllerConfirmPassword,
                  createUserWithEmailAndPassword,
                  togglePasswordVisibility,
                  signInWithEmailAndPassword,
                  handlePasswordMismatch),
              const SizedBox(height: 20),
              LoginOrRegisterButtonWidget(isLogin, toggleLoginRegister),
            ],
          ),
        ),
      ),
    );
  }
}
