import 'package:flutter/material.dart';
import 'package:mobile_app/screens/login/forgot_password_button_widget.dart';
import 'package:mobile_app/screens/login/google_widget.dart';
import '../../service/authentication/auth.dart';
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

  // Helper method to safely call safeSetState
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  void handlePasswordMismatch() {
    // Update the UI with a password mismatch error message
    safeSetState(() {
      errorMessage = 'Hasła nie są identyczne';
    });
  }

  void togglePasswordVisibility() {
    safeSetState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void toggleConfirmPasswordVisibility() {
    safeSetState(() {
      isConfirmPasswordVisible = !isConfirmPasswordVisible;
    });
  }

  void toggleLoginRegister() {
    safeSetState(() {
      isLogin = !isLogin;
      isPasswordVisible = false;
      isConfirmPasswordVisible = false;
      // Clear text fields when switching from register to login
      _controllerEmail.clear();
      _controllerPassword.clear();
    });
  }

  Future<void> signInWithEmailAndPassword() async {
    // Call the signInWithEmailAndPassword function from Auth
    String? signInErrorMessage = await Auth().signInWithEmailAndPassword(
      email: _controllerEmail.text.trim(),
      password: _controllerPassword.text.trim(),
    );

    safeSetState(() {
      errorMessage = signInErrorMessage;
    });
  }

  Future<void> createUserWithEmailAndPassword() async {
    String? createUserErrorMessage =
        await Auth().createUserWithEmailAndPassword(
      email: _controllerEmail.text.trim(),
      password: _controllerPassword.text.trim(),
      name: _controllerName.text.trim(),
    );

    safeSetState(() {
      errorMessage = createUserErrorMessage;
    });
  }

  bool isControllerNotEmpty(TextEditingController controller) {
    return controller.text.isNotEmpty;
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
                LoginFormEntry(
                  'Imię',
                  _controllerName,
                  Icons.badge,
                  false,
                  isPasswordVisible,
                  togglePasswordVisibility,
                ),
              const SizedBox(height: 10),
              LoginFormEntry(
                'E-mail',
                _controllerEmail,
                Icons.person,
                false,
                isPasswordVisible,
                togglePasswordVisibility,
              ),
              const SizedBox(height: 10),
              LoginFormEntry(
                'Hasło',
                _controllerPassword,
                Icons.lock,
                true,
                isPasswordVisible,
                togglePasswordVisibility,
              ),
              const SizedBox(height: 10),
              if (!isLogin)
                LoginFormEntry(
                  'Potwierdź hasło',
                  _controllerConfirmPassword,
                  Icons.lock,
                  true,
                  isConfirmPasswordVisible,
                  toggleConfirmPasswordVisibility,
                ),
              const SizedBox(height: 10),
              if (isLogin) const ForgotPasswordButtonWidget(),
              const SizedBox(height: 30),
              ErrorMessageWidget(errorMessage ?? ''),
              SubmitButtonWidget(
                  isLogin, _controllerPassword, _controllerConfirmPassword, () {
                if (isControllerNotEmpty(_controllerName) &&
                    isControllerNotEmpty(_controllerEmail) &&
                    isControllerNotEmpty(_controllerPassword)) {
                  createUserWithEmailAndPassword();
                } else {
                  safeSetState(() {
                    errorMessage = 'Proszę wypełnić wszystkie wymagane pola.';
                  });
                }
              }, togglePasswordVisibility, signInWithEmailAndPassword,
                  handlePasswordMismatch),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Auth().googleSignIn(),
                child: const GoogleWidget(),
              ),
              const SizedBox(height: 20),
              LoginOrRegisterButtonWidget(isLogin, toggleLoginRegister),
            ],
          ),
        ),
      ),
    );
  }
}
