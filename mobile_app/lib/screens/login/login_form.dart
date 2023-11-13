import 'package:flutter/material.dart';

class LoginFormEntry extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final IconData prefixIcon;
  final bool isPassword;
  final bool isPasswordVisible;
  final Function togglePasswordVisibility;
  final Color iconColor;
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
  State<LoginFormEntry> createState() {
    // Avoid using private types in public APIs.
    return _LoginFormEntryState();
  }
}

class _LoginFormEntryState extends State<LoginFormEntry> {
  List<String> emailSuggestions = ['gmail.com', 'wp.pl', 'onet.pl'];
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add three TextButtons for email suggestions if conditions are met
        if (widget.title.toLowerCase() == 'e-mail' &&
            widget.controller.text.contains('@') &&
            focusNode.hasFocus)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (String suggestion in emailSuggestions)
                TextButton(
                  onPressed: () {
                    // Auto-complete the email address
                    widget.controller.text =
                        '${widget.controller.text.split('@')[0]}@$suggestion';
                  },
                  child: Text(suggestion),
                ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: widget.controller,
            focusNode: focusNode,
            style: TextStyle(color: widget.textColor),
            obscureText: widget.isPassword && !widget.isPasswordVisible,
            onChanged: (text) {
              // Check if '@' is present and the title is 'E-mail'
              if (text.contains('@') &&
                  widget.title.toLowerCase() == 'e-mail') {
                String domain = text.split('@')[1];
                setState(() {
                  emailSuggestions = emailSuggestions
                      .where((suggestion) => suggestion.contains(domain))
                      .toList();
                });
              } else {
                // Reset suggestions if '@' is removed or title is not 'E-mail'
                setState(() {
                  emailSuggestions = [];
                });
              }
            },
            decoration: InputDecoration(
              hintText: widget.title,
              hintStyle: TextStyle(color: widget.iconColor),
              prefixIcon: Icon(widget.prefixIcon, color: widget.iconColor),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        widget.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: widget.iconColor,
                      ),
                      onPressed: () {
                        // Toggle password visibility
                        widget.togglePasswordVisibility();
                      },
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
