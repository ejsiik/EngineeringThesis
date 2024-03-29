import 'package:flutter/material.dart';
import 'package:mobile_app/service/database/data.dart';

import '../../../constants/colors.dart';
import '../../../service/connection/connection_check.dart';

class SubmitButton extends StatelessWidget {
  final TextEditingController _controllerUserID;
  final TextEditingController _controllerValue;
  final bool _welcomeBanner;
  final Function(String) onSubmitted;

  const SubmitButton({
    super.key,
    required TextEditingController controllerUserID,
    required TextEditingController controllerValue,
    required bool welcomeBanner,
    required this.onSubmitted,
  })  : _controllerUserID = controllerUserID,
        _controllerValue = controllerValue,
        _welcomeBanner = welcomeBanner;

  Future<void> _submitData() async {
    try {
      if (_controllerUserID.text.isNotEmpty) {
        String userId = _controllerUserID.text.trim();
        String couponValue = _controllerValue.text.trim();
        bool isInternetConnected = await checkInternetConnectivity();
        if (!isInternetConnected) {
          return;
        }
        await Data()
            .submitData(userId, _welcomeBanner, couponValue, onSubmitted);
      } else {
        onSubmitted('Wprowadź ID użytkownika');
      }
    } catch (e) {
      onSubmitted('Błąd podczas zapisu danych');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color primaryColor = theme.brightness == Brightness.light
        ? AppColors.primaryLight
        : AppColors.primaryDark;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: primaryColor,
        backgroundColor: backgroundColor,
      ),
      onPressed: _submitData,
      child: const Text('Zarejestruj zniżkę'),
    );
  }
}
