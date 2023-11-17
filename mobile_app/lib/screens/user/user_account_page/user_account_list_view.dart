import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';

class UserAccountListView extends StatelessWidget {
  final String text;
  final IconData icon;

  const UserAccountListView(
      {super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.scaffoldBackgroundColor;
    final Color backgroundColor = theme.brightness == Brightness.light
        ? AppColors.primaryLight
        : AppColors.primaryDark;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Icon(
                icon,
                size: 40,
                color: primaryColor,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 24,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
