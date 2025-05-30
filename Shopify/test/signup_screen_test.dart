import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopify/screens/signuppage.dart';

void main() {
  group('SignUpScreen Widget Tests', () {
    testWidgets('Renders all required elements', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupPage()));

      // Verify all main widgets are present
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Sign up to get started'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('SIGN UP'), findsOneWidget);
      expect(find.text('Already have an account? Log in'), findsOneWidget);
    });

    testWidgets('Email validation works', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupPage()));

      // Test empty email
      await tester.tap(find.text('SIGN UP'));
      await tester.pump();
      expect(find.text('Please enter your email'), findsOneWidget);

      // Test invalid email format
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      await tester.tap(find.text('SIGN UP'));
      await tester.pump();
      expect(find.text('Please enter a valid email'), findsOneWidget);

      // Test valid email
      await tester.enterText(find.byType(TextFormField).first, 'valid@email.com');
      await tester.tap(find.text('SIGN UP'));
      await tester.pump();
      expect(find.text('Please enter a valid email'), findsNothing);
    });

    testWidgets('Password validation works', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupPage()));

      // Enter valid email first
      await tester.enterText(find.byType(TextFormField).first, 'valid@email.com');

      // Test empty password
      await tester.tap(find.text('SIGN UP'));
      await tester.pump();
      expect(find.text('Please enter a password'), findsOneWidget);

      // Test short password
      await tester.enterText(find.byType(TextFormField).at(1), 'short');
      await tester.tap(find.text('SIGN UP'));
      await tester.pump();
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);

      // Test valid password
      await tester.enterText(find.byType(TextFormField).at(1), 'validpassword');
      await tester.tap(find.text('SIGN UP'));
      await tester.pump();
      expect(find.text('Password must be at least 6 characters'), findsNothing);
    });

    testWidgets('Password confirmation validation works', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupPage()));

      // Enter valid email and password first
      await tester.enterText(find.byType(TextFormField).first, 'valid@email.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'validpassword');

      // Test empty confirmation
      await tester.tap(find.text('SIGN UP'));
      await tester.pump();
      expect(find.text('Please confirm your password'), findsOneWidget);

      // Test mismatched passwords
      await tester.enterText(find.byType(TextFormField).at(2), 'differentpassword');
      await tester.tap(find.text('SIGN UP'));
      await tester.pump();
      expect(find.text('Passwords do not match'), findsOneWidget);

      // Test matching passwords
      await tester.enterText(find.byType(TextFormField).at(2), 'validpassword');
      await tester.tap(find.text('SIGN UP'));
      await tester.pump();
      expect(find.text('Passwords do not match'), findsNothing);
    });

    testWidgets('Password visibility toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupPage()));

      // Find the password field
      final passwordFinder = find.byType(TextFormField).at(1);

      // Verify the initial obscureText state by checking the icon
      expect(find.byIcon(Icons.visibility), findsOneWidget);

      // Tap the visibility icon to toggle
      await tester.tap(find.byIcon(Icons.visibility).first);
      await tester.pump();

      // Verify the icon has changed
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('Successful validation shows snackbar', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupPage()));

      // Enter valid data
      await tester.enterText(find.byType(TextFormField).first, 'valid@email.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'validpassword');
      await tester.enterText(find.byType(TextFormField).at(2), 'validpassword');

      // Tap sign up button
      await tester.tap(find.text('SIGN UP'));
      await tester.pump();

      // Verify snackbar appears
      expect(find.text('Processing Data'), findsOneWidget);
    });

    testWidgets('Login button is present and tappable', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupPage()));

      // Verify login text button exists
      expect(find.text('Already have an account? Log in'), findsOneWidget);

      // Tap the login button
      await tester.tap(find.text('Already have an account? Log in'));
      await tester.pump();
    });
  });
}