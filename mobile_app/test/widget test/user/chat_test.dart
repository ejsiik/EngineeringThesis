import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/screens/user/home_page/chat_page.dart';

void main() {
  testWidgets('MessageWidget displays correct sender and text',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MessageWidget('Sender', 'Hello', false),
      ),
    );

    // Use byType to find MessageWidget
    final messageWidgetFinder = find.byType(MessageWidget);

    // Expect one MessageWidget
    expect(messageWidgetFinder, findsOneWidget);

    // Extract the widget from the finder
    final messageWidget = tester.widget<MessageWidget>(messageWidgetFinder);

    // Verify the text is displayed correctly
    expect(messageWidget.sender, 'Sender');
    expect(messageWidget.text, 'Hello');
    expect(messageWidget.isMyMessage, false);
  });

  testWidgets('MessageWidget displays "Ja" for current user messages',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MessageWidget('CurrentUserId', 'Hello', true),
      ),
    );

    expect(find.text('Ja:'), findsOneWidget);
  });

  testWidgets('MessageWidget displays "Sklep" for other user messages',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MessageWidget('OtherUserId', 'Hello', false),
      ),
    );

    expect(find.text('Sklep:'), findsOneWidget);
  });
}
