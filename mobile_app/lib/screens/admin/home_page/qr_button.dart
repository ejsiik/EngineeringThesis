import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart' as scanner;

import '../../../constants/colors.dart';

class QRButton extends StatelessWidget {
  final Function(String) onScan;

  const QRButton({super.key, required this.onScan});

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
      onPressed: () async {
        try {
          var result = await scanner.BarcodeScanner.scan();
          if (result.rawContent.isNotEmpty) {
            onScan(result.rawContent);
          }
        } catch (e) {
          // Handle error
        }
      },
      child: const Text('Scan QR Code'),
    );
  }
}
