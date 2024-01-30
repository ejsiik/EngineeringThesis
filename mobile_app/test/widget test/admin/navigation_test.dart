import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/screens/admin/chat/admin_chat.dart';
import 'package:mobile_app/screens/admin/home_page/home_page.dart';
import 'package:mobile_app/screens/admin/navigation_page.dart';
import 'package:mobile_app/screens/admin/orders/users_list.dart';

void main() {
  testWidgets('NavigationPage Widget Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: NavigationPage()));

    // Verify that the initial page is displayed.
    expect(find.byType(AdminHomePage), findsOneWidget);
    expect(find.byType(AdminChatScreen), findsNothing);
    expect(find.byType(UsersList), findsNothing);
  });
}
