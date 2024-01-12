import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/service/authentication/auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constants/colors.dart';
import '../../../service/database/data.dart';
import 'coupons.dart';

class CouponCardWidget extends StatelessWidget {
  const CouponCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.brightness == Brightness.light
        ? AppColors.primaryLight
        : AppColors.primaryDark;
    final Color textColor = theme.brightness == Brightness.light
        ? AppColors.textLight
        : AppColors.textDark;

    return GestureDetector(
      onTap: () {
        _showCouponScreen(context);
      },
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.local_offer,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'Twoje Kupony',
                    style: TextStyle(fontSize: 20, color: textColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCouponScreen(BuildContext context) {
    Data data = Data();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CouponScreen(data: data),
      ),
    );
  }
}

class CouponScreen extends StatefulWidget {
  final Data data;

  const CouponScreen({Key? key, required this.data}) : super(key: key);

  @override
  _CouponScreenState createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  DatabaseReference getCouponReference(int index) {
    return widget.data.getCouponReference(Auth().userId(), index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Twoje kupony'),
      ),
      body: FutureBuilder<List<Map<dynamic, dynamic>>>(
        future: widget.data.getAllCouponData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerPlaceholder();
          } else if (snapshot.hasError) {
            return Text('Wystąpił błąd podczas pobierania danych o kuponach');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('Brak dostępnych kuponów');
          } else {
            return Column(
              children: [
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    children: snapshot.data!.asMap().entries.map((entry) {
                      int index = entry.key;

                      bool isFree = index == 5;

                      return CouponCardWithFirebaseData(
                        getCouponReference(index),
                        isFree: isFree,
                      );
                    }).toList(),
                  ),
                ),
                // Display the generated QR code below the GridView
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder<String>(
                    future: widget.data.generateQRCodeData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return _buildErrorWidget();
                        } else {
                          return _buildQRCodeWidget(snapshot.data!);
                        }
                      } else {
                        return _buildLoadingWidget();
                      }
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    final ThemeData theme = Theme.of(context);
    final Color shimmerBaseColor = theme.brightness == Brightness.light
        ? AppColors.shimmerBaseColorLight
        : AppColors.shimmerBaseColorDark;
    final Color shimmerHighlightColor = theme.brightness == Brightness.light
        ? AppColors.shimmerHighlightColorLight
        : AppColors.shimmerHighlightColorDark;
    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(6, (index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodeWidget(String data) {
    final Color backgroundQRColor = AppColors.white;
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: backgroundQRColor,
          child: QrImageView(
            data: data,
            size: 200,
            padding: const EdgeInsets.all(10.0),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Text(
        'Error generating QR code',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
