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

      testWidgets('Initial state of value, id and order code fields',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: AdminHomePage(),
          ),
        );

        // Initially, the value, id order code fields should be empty
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

        expect(find.widgetWithText(TextField, 'Wprowadź kod odbioru'),
            findsOneWidget);
        expect(
            (tester.widget(
                        find.widgetWithText(TextField, 'Wprowadź kod odbioru'))
                    as TextField)
                .controller!
                .text,
            '');
      });

      testWidgets('AppBar and TextField icon', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: AdminHomePage(),
          ),
        );

        // Check if AppBar name is correct
        expect(find.text('Shop X'), findsOneWidget);

        final orderCodeEntry =
            find.widgetWithText(TextField, 'Wprowadź kod odbioru');

        final orderCodeEntryIcon = find.descendant(
          of: orderCodeEntry,
          matching: find.byType(Icon),
        );

        // Icon within TextField
        expect(orderCodeEntryIcon, findsOneWidget);

        await tester.tap(orderCodeEntryIcon);
        await tester.pumpAndSettle();
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
