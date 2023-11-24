import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../database/data.dart';
import 'coupons.dart';

class CouponCardWidget extends StatelessWidget {
  const CouponCardWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
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
              padding: const EdgeInsets.all(10.0),
              color: backgroundColor,
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.qr_code,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'Your Amount',
                    style: TextStyle(fontSize: 20, color: textColor),
                  ),
                  Icon(
                    Icons.attach_money,
                    size: 30,
                    color: textColor,
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

class CouponScreen extends StatelessWidget {
  final Data data;

  const CouponScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Coupons'),
      ),
      body: FutureBuilder<List<Map<dynamic, dynamic>>>(
        future: data.getAllCouponData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No coupons available.');
          } else {
            return GridView.count(
              crossAxisCount: 3,
              children: snapshot.data!.map((couponData) {
                return CouponCard(
                  isFree: couponData['isFree'] ?? false,
                  wasUsed: couponData['wasUsed'] ?? false,
                  couponValue: couponData['couponValue'] ?? 0,
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
