import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopify/screens/homepage.dart';
import 'package:shopify/screens/loginpage.dart';

void main() {
  group('HomePage Widget Tests', () {
    testWidgets('Navigates to HomePage on tap', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomePage()));
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Search Product...'), findsOneWidget);
    });

    testWidgets('Navigates to BookmarkPage on tap', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: HomePage()));
      await tester.tap(find.text('Bookmarks'));
      await tester.pumpAndSettle();
      expect(find.text('This is the Bookmark page'), findsOneWidget);
    });

    testWidgets('Navigates to Profile page on tap', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: HomePage()));
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.text("Welcome Back"), findsOneWidget);
    });

    testWidgets('Navigates to LoginPage if user not registered', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: HomePage()));
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}
