import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/screens/login/login_form.dart';

void main() {
  testWidgets('LoginFormEntry widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoginFormEntry(
            'Password',
            TextEditingController(),
            Icons.lock,
            true,
            false,
            () {},
          ),
        ),
      ),
    );

    // Find password TextField
    final passwordTextField = find.byType(TextField);

    // Verify that the password TextField is rendered
    expect(passwordTextField, findsOneWidget);

    // Find the IconButton within the password TextField
    final visibilityIconButton = find.descendant(
      of: passwordTextField,
      matching: find.byType(IconButton),
    );

    // Verify that the IconButton is present
    expect(visibilityIconButton, findsOneWidget);

    // Tap on the IconButton
    await tester.tap(visibilityIconButton);
    await tester.pump();

    // Verify that the password visibility is toggled
    expect(find.byIcon(Icons.visibility), findsNothing);
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
  });

  testWidgets('LoginFormEntry widget test - Email Field',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoginFormEntry(
            'E-mail',
            TextEditingController(),
            Icons.email,
            false,
            false,
            () {},
          ),
        ),
      ),
    );

    // Find email TextField
    final emailTextField = find.byType(TextField);

    // Verify that the email TextField is rendered
    expect(emailTextField, findsOneWidget);

    // Enter text into the email TextField
    await tester.enterText(emailTextField, 'test@example.com');
    await tester.pump();

    // Verify that the entered text is present
    expect(find.text('test@example.com'), findsOneWidget);

    // Ensure that email suggestions are not visible
    expect(find.text('gmail.com'), findsNothing);
    expect(find.text('wp.pl'), findsNothing);
    expect(find.text('onet.pl'), findsNothing);
  });
}
