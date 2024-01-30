import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/screens/user/home_page/coupons.dart';

void main() {
  testWidgets('CouponCard displays CircularProgressIndicator when waiting',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CouponCardWithMockData(
            isFree: true, wasUsed: true, couponValue: 10),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('CouponCard displays Gratis text when isFree is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CouponCardWithMockData(
            isFree: true, wasUsed: true, couponValue: 10),
      ),
    );

    expect(find.text('Gratis'), findsOneWidget);
  });

  testWidgets('CouponCard displays coupon value when wasUsed is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CouponCardWithMockData(
            isFree: false, wasUsed: true, couponValue: 10),
      ),
    );

    expect(find.text('10'), findsOneWidget);
  });
}

class CouponCardWithMockData extends StatelessWidget {
  const CouponCardWithMockData({
    Key? key,
    required this.isFree,
    required this.wasUsed,
    required this.couponValue,
  }) : super(key: key);

  final bool isFree;
  final bool wasUsed;
  final int couponValue;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CouponCard(
        isFree: isFree,
        wasUsed: wasUsed,
        couponValue: couponValue,
      ),
    );
  }
}
