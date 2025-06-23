import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shopify/screens/loginpage.dart';
import 'package:shopify/services/auth_service.dart';

String? validateEmail(String? value) {
  if (value == null || value.isEmpty || !value.contains('@')) {
    return 'Please enter a valid email';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty || value.length < 6) {
    return 'Password must be at least 6 characters long';
  }
  return null;
}

class MockAuthService extends AuthService {
  @override
  Future<void> login(String email, String password) async {
    if (email != 'test@example.com' || password != '123456') {
      throw Exception('Invalid credentials');
    }
  }
}

void main() {
  group('LoginPage Tests', () {
    group('Unit tests - validation logic', () {
      test('Empty email returns error', () {
        expect(validateEmail(''), 'Please enter a valid email');
      });

      test('Invalid email returns error', () {
        expect(validateEmail('invalid.com'), 'Please enter a valid email');
      });

      test('Valid email returns null', () {
        expect(validateEmail('test@example.com'), null);
      });

      test('Email with spaces is trimmed and valid', () {
        expect(validateEmail('  test@example.com  '), null);
      });

      test('Short password returns error', () {
        expect(
          validatePassword('123'),
          'Password must be at least 6 characters long',
        );
      });

      test('Password with spaces counts length correctly', () {
        expect(validatePassword(' 123456 '), null);
      });

      test('Valid password returns null', () {
        expect(validatePassword('123456'), null);
      });
    });

    group('Widget tests - LoginPage rendering and behavior', () {
      testWidgets('WT/LoginPage displays email and password fields', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider<AuthService>.value(
              value: MockAuthService(),
              child: LoginPage(),
            ),
          ),
        );

        expect(find.text('Welcome Back'), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(find.text('Login'), findsOneWidget);
      });
      // I changed line 193 in Loginpage.dart from Row() to Wrap() to fix the overflow issue

      testWidgets('WT/Tapping sign up link navigates to SignupPage', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider<AuthService>.value(
              value: MockAuthService(),
              child: const LoginPage(),
            ),
          ),
        );

        await tester.tap(find.text('Sign up'));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('Already have an account? '),
          findsOneWidget,
        );
      });
      // I changed line 280 in Signuppage.dart from Row() to Wrap() to fix the overflow issue

      testWidgets('WT/Invalid input shows validation messages', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider<AuthService>.value(
              value: MockAuthService(),
              child: const LoginPage(),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField).at(0), 'bademail');
        await tester.enterText(find.byType(TextFormField).at(1), '123');

        await tester.tap(find.text('Login'));
        await tester.pump();

        expect(find.text('Please enter a valid email'), findsOneWidget);
        expect(
          find.text('Password must be at least 6 characters long'),
          findsOneWidget,
        );
      });
    });
  });
}
