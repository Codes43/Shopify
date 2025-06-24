import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shopify/widgets/common_bottom_nav.dart';
import 'package:shopify/services/auth_service.dart';
import 'package:shopify/provider/favorites_provider.dart';
import 'package:shopify/models/product_model.dart';

Widget makeTestableWidget(Widget child, {AuthService? authService}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => authService ?? AuthService()),
      ChangeNotifierProvider(create: (_) => FavoritesProvider()),
    ],
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

bool isBookmarkBadgeVisible(List favorites) => favorites.isNotEmpty;

String getProfileLabel(bool isAuthenticated) =>
    isAuthenticated ? 'ProfilePage' : 'LoginPage';

IconData getIconForIndex(int index) {
  switch (index) {
    case 0:
      return Icons.home;
    case 1:
      return Icons.bookmark_border;
    case 2:
      return Icons.person;
    default:
      return Icons.help_outline;
  }
}

bool shouldPreventRedundantNavigation(int tappedIndex, int currentIndex) =>
    tappedIndex == currentIndex;

int getFavoritesCount(List list) => list.length;

Color getSelectedColor(bool isSelected) =>
    isSelected ? Colors.black : Colors.grey;

String getRouteNameForIndex(int index, bool isUserRegistered) {
  switch (index) {
    case 0:
      return 'HomePage';
    case 1:
      return 'BookmarkPage';
    case 2:
      return isUserRegistered ? 'ProfilePage' : 'LoginPage';
    default:
      return 'Unknown';
  }
}

void main() {
  group('CommonBottomNav Widget & Unit Tests', () {
    testWidgets('WT: Renders 3 BottomNavigationBar items', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(const CommonBottomNav(currentIndex: 0)),
      );
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('WT: Badge content reflects correct favorites count', (
      tester,
    ) async {
      final provider = FavoritesProvider();
      provider.toggleFavorite(
        Product(
          id: 1,
          name: 'Test Product',
          description: 'Test Description',
          price: 9.99,
          imageUrl: 'https://example.com/image.png',
        ),
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthService()),
            ChangeNotifierProvider<FavoritesProvider>.value(value: provider),
          ],
          child: const MaterialApp(
            home: Scaffold(body: CommonBottomNav(currentIndex: 0)),
          ),
        ),
      );

      expect(find.text('1'), findsOneWidget);
    });

    test('IsBookmarkBadgeVisible returns true when list not empty', () {
      expect(isBookmarkBadgeVisible(['fav']), isTrue);
      expect(isBookmarkBadgeVisible([]), isFalse);
    });

    test('GetProfileLabel returns correct screen name', () {
      expect(getProfileLabel(true), 'ProfilePage');
      expect(getProfileLabel(false), 'LoginPage');
    });

    test('GetIconForIndex returns correct icon', () {
      expect(getIconForIndex(0), Icons.home);
      expect(getIconForIndex(1), Icons.bookmark_border);
      expect(getIconForIndex(2), Icons.person);
      expect(getIconForIndex(99), Icons.help_outline);
    });

    test('ShouldPreventRedundantNavigation works', () {
      expect(shouldPreventRedundantNavigation(1, 1), isTrue);
      expect(shouldPreventRedundantNavigation(0, 1), isFalse);
    });

    test('GetFavoritesCount returns correct count', () {
      expect(getFavoritesCount(['a', 'b']), 2);
      expect(getFavoritesCount([]), 0);
    });

    test('GetSelectedColor returns black if selected', () {
      expect(getSelectedColor(true), Colors.black);
      expect(getSelectedColor(false), Colors.grey);
    });

    test('GetRouteNameForIndex returns correct route name', () {
      expect(getRouteNameForIndex(0, true), 'HomePage');
      expect(getRouteNameForIndex(1, true), 'BookmarkPage');
      expect(getRouteNameForIndex(2, true), 'ProfilePage');
      expect(getRouteNameForIndex(2, false), 'LoginPage');
      expect(getRouteNameForIndex(99, false), 'Unknown');
    });
  });
}
