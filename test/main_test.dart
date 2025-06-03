import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopify/main.dart';
import 'package:shopify/screens/loginpage.dart';

void main() {
  group('HomePage Widget Tests', () {
    testWidgets('Displays Shopify title', (WidgetTester tester) async {
      await tester.pumpWidget(Shopify());
      expect(find.text('Shopifty'), findsOneWidget);
    });

    testWidgets('Cart icon is there', (WidgetTester tester) async {
      await tester.pumpWidget(Shopify());
      expect(find.byIcon(Icons.shopping_cart), findsNWidgets(1));
    });

    testWidgets('Cart icon button is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(Shopify());
      final cartIcon = find.byIcon(Icons.shopping_cart);
      expect(cartIcon, findsOneWidget);
      await tester.tap(cartIcon);
      await tester.pump();
    });

    testWidgets('Search bar and both search icons are present', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(Shopify());
      expect(find.byIcon(Icons.search), findsNWidgets(2));
      expect(find.byType(TextField), findsOneWidget);
      expect(
        find.widgetWithText(TextField, 'Search Product...'),
        findsOneWidget,
      );
    });

    testWidgets('Bottom Navigation Bar has 3 items with their own icons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(Shopify());
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byIcon(Icons.home), findsNWidgets(1));
      expect(find.text('Home'), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_border), findsNWidgets(1));
      expect(find.text('Bookmarks'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsNWidgets(1));
      expect(find.text('Profile'), findsOneWidget);
    });

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
