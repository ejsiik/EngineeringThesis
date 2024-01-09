import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class GoogleWidget extends StatelessWidget {
  const GoogleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color textColor = theme.brightness == Brightness.light
        ? AppColors.textLight
        : AppColors.textDark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Divider(thickness: 0.5, color: textColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Lub zaloguj z',
                  style: TextStyle(color: textColor),
                ),
              ),
              Expanded(
                child: Divider(thickness: 0.5, color: textColor),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset(
              'assets/google-icon.png',
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }
}
