import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class EntryField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final IconData prefixIcon;
  final bool welcomeBanner;
  final Function(String) onValueChanged; // Callback function

  const EntryField({
    super.key,
    required this.title,
    required this.controller,
    required this.prefixIcon,
    this.welcomeBanner = false,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color navbarSelectedColor = theme.brightness == Brightness.light
        ? AppColors.navbarSelectedLight
        : AppColors.navbarSelectedDark;
    final Color navbarUnselectedColor = theme.brightness == Brightness.light
        ? AppColors.navbarUnselectedLight
        : AppColors.navbarUnselectedDark;
    final Color primaryColor = theme.brightness == Brightness.light
        ? AppColors.primaryLight
        : AppColors.primaryDark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title == 'Cena')
            Row(
              children: [
                Checkbox(
                  value: welcomeBanner,
                  onChanged: (value) {
                    onValueChanged(
                        value.toString()); // Call the callback function
                  },
                  activeColor: navbarSelectedColor,
                  checkColor: navbarUnselectedColor,
                  fillColor: MaterialStateColor.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return primaryColor;
                    }
                    return primaryColor;
                  }),
                ),
                Text(
                  'Kupon powitalny',
                  style: TextStyle(color: primaryColor),
                ),
              ],
            ),
          TextField(
            controller: controller,
            enabled: title != 'Wartość' || !welcomeBanner,
            style: TextStyle(color: primaryColor),
            decoration: InputDecoration(
              hintText: title,
              hintStyle: TextStyle(color: primaryColor),
              prefixIcon: Icon(prefixIcon, color: primaryColor),
            ),
            keyboardType:
                title == 'Wartość' ? TextInputType.number : TextInputType.text,
          ),
        ],
      ),
    );
  }
}
