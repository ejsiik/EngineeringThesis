import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';

class LoginFormEntry extends StatefulWidget {
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
  State<LoginFormEntry> createState() {
    // Avoid using private types in public APIs.
    return _LoginFormEntryState();
  }
}

class _LoginFormEntryState extends State<LoginFormEntry> {
  List<String> emailSuggestions = ['gmail.com', 'wp.pl', 'onet.pl'];
  FocusNode focusNode = FocusNode();

  // Helper method to safely call safeSetState
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      safeSetState(() {});
    });
  }

  List<String> generateEmailSuggestions(String text) {
    if (text.contains('@')) {
      final prefix = text.substring(0, text.indexOf('@') + 1);
      return emailSuggestions
          .map((domain) => '$prefix$domain')
          .where((domain) => domain.startsWith(text))
          .toList();
    } else {
      return [];
    }
  }

  void updateEmailSuggestions(String text) {
    if (text.contains('@') && widget.title.toLowerCase() == 'e-mail') {
      String domain = text.split('@')[1];
      safeSetState(() {
        emailSuggestions = emailSuggestions
            .where((suggestion) => suggestion.contains(domain))
            .toList();
      });
    } else {
      safeSetState(() {
        emailSuggestions = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color iconColor = theme.brightness == Brightness.light
        ? AppColors.iconLight
        : AppColors.iconDark;
    final Color textColor = theme.brightness == Brightness.light
        ? AppColors.textLight
        : AppColors.textDark;

    if (widget.title.toLowerCase() == 'e-mail') {
      return Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          final suggestions = generateEmailSuggestions(textEditingValue.text);
          return suggestions;
        },
        onSelected: (String selectedEmail) {
          widget.controller.text = selectedEmail;
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: 'Wprowadź email',
              hintStyle: TextStyle(color: iconColor),
              prefixIcon: Icon(widget.prefixIcon, color: iconColor),
            ),
          );
        },
      );
    } else {
      return TextField(
        controller: widget.controller,
        focusNode: focusNode,
        style: TextStyle(color: textColor),
        obscureText: widget.isPassword && !widget.isPasswordVisible,
        onChanged: (text) => updateEmailSuggestions(text),
        decoration: InputDecoration(
          hintText: widget.title,
          hintStyle: TextStyle(color: iconColor),
          prefixIcon: Icon(widget.prefixIcon, color: iconColor),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    widget.isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: iconColor,
                  ),
                  onPressed: () {
                    widget.togglePasswordVisibility();
                  },
                )
              : null,
        ),
      );
    }
  }
}
