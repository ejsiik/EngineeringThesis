import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart' as scanner;
import 'package:url_launcher/url_launcher.dart';


import '../../../constants/colors.dart';

class QRButton extends StatelessWidget {
  final Function(String) onScan;

  const QRButton({Key? key, required this.onScan}) : super(key: key);

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
          // cammera access denied
          if (e.toString().contains("PERMISSION_NOT_GRANTED")) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Błąd'),
                  content: Text('Aby skanować kody QR, udziel dostępu do aparatu w ustawieniach aplikacji.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _openAppSettings();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else {
            throw 'Wystąpił błąd podczas skanowania: $e';
          }
        }
      },
      child: const Text('Skanuj kod QR'),
    );
  }
void _openAppSettings() async {
    // Use the url_launcher package to open the app settings
    final Uri url = Uri.parse('app-settings:');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
