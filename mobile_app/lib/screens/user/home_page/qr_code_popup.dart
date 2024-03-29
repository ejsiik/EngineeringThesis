import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';
import 'package:mobile_app/constants/text_strings.dart';
import 'package:mobile_app/constants/theme.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../service/connection/connection_check.dart';
import '../../../service/database/data.dart';

class QRCodePopup extends StatelessWidget {
  const QRCodePopup({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = AppTheme.lightTheme.scaffoldBackgroundColor;
    final Color textColor = theme.brightness == Brightness.light
        ? AppColors.textLight
        : AppColors.textDark;
    const Color blackColor = AppColors.black;
    final Color shimmerBaseColor = theme.brightness == Brightness.light
        ? AppColors.shimmerBaseColorLight
        : AppColors.shimmerBaseColorDark;
    final Color shimmerHighlightColor = theme.brightness == Brightness.light
        ? AppColors.shimmerHighlightColorLight
        : AppColors.shimmerHighlightColorDark;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FutureBuilder<String>(
                  future: _generateQRCode(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return _buildErrorWidget(textColor);
                      } else {
                        // Display the generated QR code
                        return _buildQRCodeWidget(
                            snapshot.data!, backgroundColor);
                      }
                    } else {
                      return Shimmer.fromColors(
                        baseColor: shimmerBaseColor,
                        highlightColor: shimmerHighlightColor,
                        child: Container(
                          color: Colors.white,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          // Positioned close icon at the top-right corner
          Positioned(
            top: 2.0,
            right: 2.0,
            child: IconButton(
              icon: const Icon(Icons.close, color: blackColor),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  // Future method to generate QR code data
  Future<String> _generateQRCode() async {
    try {
      bool isInternetConnected = await checkInternetConnectivity();
      if (!isInternetConnected) {
        return connection;
      }
      return await Data().generateQRCodeData();
    } catch (e) {
      rethrow;
    }
  }

  // Widget to display the generated QR code
  Widget _buildQRCodeWidget(String data, Color backgroundColor) {
    return Center(
      child: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: QrImageView(
          data: data,
        ),
      ),
    );
  }

  Widget _buildErrorWidget(Color textColor) {
    return Center(
      child: Text(
        'Error generating QR code',
        style: TextStyle(color: textColor),
      ),
    );
  }
}
