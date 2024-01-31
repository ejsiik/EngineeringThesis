import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/screens/user/user_account_page/user_account_list_view.dart';
import 'package:mobile_app/screens/user/user_account_page/user_account_page.dart';

void main() {
  testWidgets('UserAccountPage widget render test',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: UserAccountPage(),
      ),
    ));

    // Sprawdza, czy widok poprawnie się renderuje
    expect(find.byType(UserAccountPage), findsOneWidget);
  });

  testWidgets('UserAccountPage content test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: UserAccountPage(),
      ),
    ));

    // Sprawdza, czy tytuł AppBar jest poprawny
    expect(find.text('Panel użytkownika'), findsOneWidget);

    final activeOrders =
        find.widgetWithText(UserAccountListView, 'Aktywne zamówienia');
    final completedOrders =
        find.widgetWithText(UserAccountListView, 'Zamówienia zrealizowane');
    final purchasedProducts =
        find.widgetWithText(UserAccountListView, 'Zakupione produkty');
    final followedProducts =
        find.widgetWithText(UserAccountListView, 'Obserwowane produkty');
    final accountSettings =
        find.widgetWithText(UserAccountListView, 'Ustawienia konta');

    // Sprawdza, czy elementy UserAccountListView są renderowane w ListView
    expect(activeOrders, findsOneWidget);
    expect(completedOrders, findsOneWidget);
    expect(purchasedProducts, findsOneWidget);
    expect(followedProducts, findsOneWidget);
    expect(accountSettings, findsOneWidget);
  });

  testWidgets('UserAccountPage interaction test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: UserAccountPage(),
      ),
    ));

    final activeOrders =
        find.widgetWithText(UserAccountListView, 'Aktywne zamówienia');
    final completedOrders =
        find.widgetWithText(UserAccountListView, 'Zamówienia zrealizowane');
    final purchasedProducts =
        find.widgetWithText(UserAccountListView, 'Zakupione produkty');
    final followedProducts =
        find.widgetWithText(UserAccountListView, 'Obserwowane produkty');
    final accountSettings =
        find.widgetWithText(UserAccountListView, 'Ustawienia konta');

    // Sprawdza, czy tapnięcie na elementy UserAccountListView wywołuje interakcje
    await tester.tap(activeOrders);
    await tester.pumpAndSettle();

    await tester.tap(completedOrders);
    await tester.pumpAndSettle();

    await tester.tap(purchasedProducts);
    await tester.pumpAndSettle();

    await tester.tap(followedProducts);
    await tester.pumpAndSettle();

    await tester.tap(accountSettings);
    await tester.pumpAndSettle();
  });
}
