import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/screens/user/home_page/welcome_banner.dart';

void main() {
  testWidgets('WelcomeBanner Widget Test', (WidgetTester tester) async {
    // Variable to store whether the button is pressed
    bool isButtonPressed = false;

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: WelcomeBanner(
        onButtonPressed: () {
          // Set the variable to true when the button is pressed
          isButtonPressed = true;
        },
      ),
    ));

    // Verify that the initial UI is correct.
    expect(
        find.text(
            'Przyznano 10% zniżki na akcesoria!\nKupon ważny przez 2 tygodnie od założenia konta.'),
        findsOneWidget);
    expect(find.text('Wykorzystaj kupon'), findsOneWidget);

    // Tap on the button and verify if the callback is triggered
    await tester.tap(find.text('Wykorzystaj kupon'));
    await tester.pumpAndSettle();

    // Verify that the button callback is triggered
    expect(isButtonPressed, true);
  });
}
