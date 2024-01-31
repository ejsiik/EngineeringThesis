import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/screens/admin/home_page/home_page.dart';

void main() {
  group('AdminHomePage Widget Tests', () {
    group('AdminHomePage Widget Tests', () {
      testWidgets('Widget renders correctly', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: AdminHomePage()));
        expect(find.byType(AdminHomePage), findsOneWidget);
      });

      testWidgets('Initial state of value and id fields',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: AdminHomePage(),
          ),
        );

        // Initially, the value and id fields should be empty
        expect(find.widgetWithText(TextField, 'Wartość'), findsOneWidget);
        expect(
            find.widgetWithText(TextField, 'ID Użytkownika'), findsOneWidget);
        expect(
            (tester.widget(find.widgetWithText(TextField, 'Wartość'))
                    as TextField)
                .controller!
                .text,
            '');
        expect(
            (tester.widget(find.widgetWithText(TextField, 'ID Użytkownika'))
                    as TextField)
                .controller!
                .text,
            '');
      });

      testWidgets('Checkbox disables value field', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: AdminHomePage(),
          ),
        );

        // Initially, the value field should be enabled
        expect(
            (tester.widget(find.widgetWithText(TextField, 'Wartość'))
                    as TextField)
                .enabled,
            true);

        // Tap the welcomeBanner checkbox
        await tester.tap(find.byType(Checkbox));
        await tester.pump();

        // After tapping, the value field should be disabled
        expect(
            (tester.widget(find.widgetWithText(TextField, 'Wartość'))
                    as TextField)
                .enabled,
            false);
      });
    });

    testWidgets('WelcomeBannerCheckbox state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AdminHomePage(),
        ),
      );

      // Initially, the welcomeBanner checkbox should be unchecked
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, false);

      // Tap the welcomeBanner checkbox
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // After tapping, the welcomeBanner checkbox should be checked
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
    });
  });
}
