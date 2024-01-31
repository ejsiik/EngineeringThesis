import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/screens/user/user_account_page/user_account_list_view.dart';

void main() {
  testWidgets('UserAccountListView content test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserAccountListView(
            text: "List item",
            icon: Icons.list,
            type: "testType",
          ),
        ),
      ),
    );

    final listItem = find.byType(GestureDetector);

    // Sprawdź, czy dokładnie jeden widżet GestureDetector został znaleziony
    expect(listItem, findsOneWidget);

    final listItemText = find.descendant(
      of: listItem,
      matching: find.byType(Text),
    );

    final listItemIcon = find.descendant(
      of: listItem,
      matching: find.byType(Icon),
    );

    // Sprawdź, czy znalezione zostały odpowiednie widgety jako wewnątrz GestureDetector
    expect(listItemText, findsOneWidget);
    expect(listItemIcon, findsOneWidget);
  });
}
