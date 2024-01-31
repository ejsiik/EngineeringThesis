import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/screens/user/user_account_page/user_settings.dart';

void main() {
  testWidgets('UserSettings widget render test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: UserSettings(),
      ),
    ));

    // Sprawdza, czy widok poprawnie się renderuje
    expect(find.byType(UserSettings), findsOneWidget);
  });

  testWidgets('UserSettings content test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: UserSettings(),
      ),
    ));

    // Sprawdza, czy tytuł AppBar jest poprawny
    expect(find.text('Ustawienia użytkownika'), findsOneWidget);

    // Sprawdź, czy są renedrowane odpowiednie elementy z właściwym tekstem
    expect(find.widgetWithText(TextField, 'Zmień imię'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Zmień imię'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'WYLOGUJ SIĘ'), findsOneWidget);
    expect(find.widgetWithText(GestureDetector, 'Usuń konto'), findsOneWidget);

    // Sprawdź, czy pole tekstowe jest na początku puste
    expect(
      (tester.widget(find.byType(TextField)) as TextField).controller!.text,
      '',
    );
  });

  testWidgets('UserSettings interaction test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: UserSettings(),
      ),
    ));

    String newName = "New name";

    // Znajdź pole 'Zmień imię' i wprowadź nowe imię
    final nameTextField = find.widgetWithText(TextField, 'Zmień imię');
    await tester.enterText(nameTextField, newName);

    // Sprawdź, czy wartość pola tekstowego została ustawiona poprawnie
    expect(
      (tester.widget(nameTextField) as TextField).controller!.text,
      newName,
    );

    // Znajdź przycisk 'Usuń konto' i naciśnij go
    final deleteAccountText =
        find.widgetWithText(GestureDetector, 'Usuń konto');
    await tester.tap(deleteAccountText);
    await tester.pumpAndSettle();

    // Sprawdź, czy wyświetlił się dialog potwierdzenia
    expect(find.byType(AlertDialog), findsOneWidget);
  });
}
