import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopify/screens/loginpage.dart';
import 'package:shopify/screens/signuppage.dart';

void main() {
  group('LoginPage Widget Tests', () {
    testWidgets('Displays welcome text', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));
      expect(find.text('Welcome Back'), findsOneWidget);
    });

    testWidgets('Has email and password fields', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    });

    testWidgets('Login button is present and triggers validation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));
      await tester.tap(find.text('Login'));
      await tester.pump();
      expect(find.text('Please enter a valid email'), findsOneWidget);
      expect(
        find.text('Password must be at least 4 characters long'),
        findsOneWidget,
      );
    });

    testWidgets('Signup link navigates to SignupPage', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
          routes: {'/signup': (_) => SignupPage()},
        ),
      );

      final signupText = find.text('Signup');
      expect(signupText, findsOneWidget);

      await tester.tap(signupText);
      await tester.pumpAndSettle();

      expect(find.byType(SignupPage), findsOneWidget);
    });

    testWidgets('Forgot password text is displayed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));
      expect(find.text('Forgot password?'), findsOneWidget);
    });

    testWidgets('Entering valid credentials removes validation errors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'user@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        '1234',
      );

      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsNothing);
      expect(
        find.text('Password must be at least 4 characters long'),
        findsNothing,
      );
    });
  });
}
