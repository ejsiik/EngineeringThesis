import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/constants/colors.dart';
import 'package:mobile_app/screens/login/error_message_widget.dart';

void main() {
  testWidgets('ErrorMessageWidget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ErrorMessageWidget('Test Error Message'),
        ),
      ),
    );

    // Find the widget
    final errorMessageWidget = find.byType(ErrorMessageWidget);

    // Verify that the widget is rendered
    expect(errorMessageWidget, findsOneWidget);

    // Find the Text widget within ErrorMessageWidget
    final textWidget = find.descendant(
      of: errorMessageWidget,
      matching: find.byType(Text),
    );

    // Verify that the Text widget has the correct style and content
    expect(
      textWidget,
      findsOneWidget,
      reason: 'ErrorMessageWidget should contain exactly one Text widget',
    );

    final textWidgetFinder = tester.widget<Text>(textWidget);
    expect(textWidgetFinder.style?.color, AppColors.accent);
    expect(textWidgetFinder.style?.decoration, TextDecoration.underline);
    expect(textWidgetFinder.data, 'Test Error Message');
  });
}
