import 'package:flutter/material.dart';
import '../../authentication/auth.dart';

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

  Widget _entryField(
    String title,
    TextEditingController controller,
    IconData prefixIcon,
    bool isPassword,
  ) {
    final ThemeData theme = Theme.of(context);
    final Color? textColor = isPassword
        ? theme.textTheme.bodyMedium!.color
        : theme.textTheme.bodyMedium!.color;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        style: TextStyle(color: textColor),
        obscureText:
            isPassword && !isPasswordVisible, // Use the visibility state
        decoration: InputDecoration(
          hintText: title,
          hintStyle: TextStyle(color: textColor),
          prefixIcon: Icon(prefixIcon, color: Colors.grey),
          // Add a suffix icon for password visibility
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: textColor,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _errorMessage() {
    final ThemeData theme = Theme.of(context);
    final Color? accentColor = theme.textTheme.bodyLarge!.color;

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: Text(
        errorMessage == '' ? '' : '$errorMessage',
        style: TextStyle(
          color: accentColor,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _submitButton() {
    final ThemeData theme = Theme.of(context);
    final Color? textColor = theme.textTheme.bodyLarge!.color;
    final Color buttonColor = theme.primaryColor;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: buttonColor,
      ),
      onPressed: isLogin
          ? signInWithEmailAndPassword
          : () {
              if (_controllerPassword.text.trim() ==
                  _controllerConfirmPassword.text.trim()) {
                createUserWithEmailAndPassword();
              } else {
                setState(() {
                  errorMessage = 'Passwords do not match';
                });
              }
              FocusScope.of(context).unfocus();
            },
      child: Text(isLogin ? 'LOGIN' : 'REGISTER'),
    );
  }

  Widget _loginOrRegisterButton() {
    final ThemeData theme = Theme.of(context);
    final Color? textColor = theme.textTheme.bodyLarge!.color;

    return GestureDetector(
      onTap: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(
        isLogin
            ? 'Not a member? Register now'
            : 'Already have an account? Login',
        style: TextStyle(
          color: textColor,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.scaffoldBackgroundColor;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: primaryColor,
        body: Container(
          color: primaryColor,
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                const SizedBox(height: 80),
                if (!isLogin)
                  _entryField('Name', _controllerName, Icons.badge, false),
                const SizedBox(height: 10),
                _entryField('E-mail', _controllerEmail, Icons.person, false),
                const SizedBox(height: 10),
                _entryField('Password', _controllerPassword, Icons.lock, true),
                const SizedBox(height: 10),
                if (!isLogin)
                  _entryField('Confirm password', _controllerConfirmPassword,
                      Icons.lock, true),
                const SizedBox(height: 30),
                _errorMessage(),
                _submitButton(),
                const SizedBox(height: 20),
                _loginOrRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
