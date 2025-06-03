// test/screens/signup_test.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopify/screens/loginpage.dart';
import 'package:shopify/screens/signuppage.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late NavigatorObserver mockObserver;

  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  Future<void> pumpSignupPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const SignupPage(),
        navigatorObservers: [mockObserver],
        routes: {
          '/login': (context) =>  LoginPage(),
        },
      ),
    );
    await tester.pumpAndSettle();
  }

  group('SignupPage', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await pumpSignupPage(tester);

      expect(find.text('Create Account'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.text('SIGN UP'), findsOneWidget);
      expect(find.text('Already have an account?'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('validates empty email', (WidgetTester tester) async {
      await pumpSignupPage(tester);

      await tester.tap(find.text('SIGN UP'));
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('validates invalid email format', (WidgetTester tester) async {
      await pumpSignupPage(tester);

      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      await tester.tap(find.text('SIGN UP'));
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('validates empty password', (WidgetTester tester) async {
      await pumpSignupPage(tester);

      // Enter valid email
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.tap(find.text('SIGN UP'));
      await tester.pump();

      expect(find.text('Please enter a password'), findsOneWidget);
    });

    testWidgets('validates short password', (WidgetTester tester) async {
      await pumpSignupPage(tester);

      await tester.enterText(find.byType(TextFormField).at(1), '12345');
      await tester.tap(find.text('SIGN UP'));
      await tester.pump();

      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('validates password confirmation', (WidgetTester tester) async {
      await pumpSignupPage(tester);

      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.enterText(find.byType(TextFormField).at(2), 'different');
      await tester.tap(find.text('SIGN UP'));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('toggles password visibility', (WidgetTester tester) async {
      await pumpSignupPage(tester);

      // Find the password field and its visibility toggle button
      final passwordFields = find.byType(TextFormField);
      final passwordField = passwordFields.at(1);
      final visibilityIcon = find.descendant(
        of: passwordField,
        matching: find.byType(IconButton),
      );

      // Helper function to check obscureText state
      bool isObscured() {
        final textField = tester.widget<TextField>(
          find.descendant(
            of: passwordField,
            matching: find.byType(TextField),
          ),
        );
        return textField.obscureText;
      }

      // Password should be obscured by default
      expect(isObscured(), isTrue);

      // Tap to show password
      await tester.tap(visibilityIcon);
      await tester.pump();
      expect(isObscured(), isFalse);

      // Tap to hide password again
      await tester.tap(visibilityIcon);
      await tester.pump();
      expect(isObscured(), isTrue);
    });
    testWidgets('shows snackbar on valid form submission', (WidgetTester tester) async {
      await pumpSignupPage(tester);

      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');
      await tester.tap(find.text('SIGN UP'));
      await tester.pump();

      expect(find.text('Processing Data'), findsOneWidget);
    });

    testWidgets('navigates to login page when Sign In is tapped', (WidgetTester tester) async {
      await pumpSignupPage(tester);

      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      verify(() => mockObserver.didPush(any(), any()));
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('shows underline when hovering over Sign In', (WidgetTester tester) async {
      await pumpSignupPage(tester);

      final signInFinder = find.text('Sign In');
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer();
      await gesture.moveTo(tester.getCenter(signInFinder));

      await tester.pump();

      final textWidget = tester.widget<Text>(signInFinder);
      expect(textWidget.style?.decoration, TextDecoration.underline);
    });
  });
}