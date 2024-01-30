import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/screens/user/user_account_page/user_account_page.dart';

void main() {
  testWidgets('UserAccountPage Widget Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: UserAccountPage()));

    // Verify that the initial UI is correct.
    expect(find.text("Aktywne zamówienia"), findsOneWidget);
    expect(find.text("Zamówienia zrealizowane"), findsOneWidget);
    expect(find.text("Zakupione produkty"), findsOneWidget);
    expect(find.text("Obserwowane produkty"), findsOneWidget);
    expect(find.text("Ustawienia konta"), findsOneWidget);

    // Tap on each item and verify the expected action.
    await tester.tap(find.text("Aktywne zamówienia"));
    await tester.pumpAndSettle(); // Wait for animations to complete.

    await tester.tap(find.text("Zamówienia zrealizowane"));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Zakupione produkty"));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Obserwowane produkty"));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Ustawienia konta"));
    await tester.pumpAndSettle();

    // Dispose of the tester.
    await tester.pumpAndSettle();
  });
}
