import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shopify/screens/searchresultspage.dart';
import 'package:shopify/services/auth_service.dart';
import 'package:shopify/provider/favorites_provider.dart';

String generateErrorMessage(dynamic error) => 'Failed to load results: $error';

String getNoResultsMessage(String term) => 'No results found for "$term"';

bool shouldShowSearchButton(String input) => input.trim().isNotEmpty;

bool isValidSearch(String term) => term.trim().length >= 2;

bool isImageAvailable(String url) => url.trim().isNotEmpty;

int calculateGridCrossAxisCount(double screenWidth) =>
    screenWidth < 600 ? 2 : 4;

double calculateAspectRatio(bool isTablet) => isTablet ? 4 / 3 : 3 / 4;

bool hasError(String msg) => msg.toLowerCase().contains('fail');

void main() {
  group('SearchResultsPage Widget & Unit Tests', () {
    Widget makeTestableWidget(Widget child) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthService()),
          ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ],
        child: MaterialApp(home: child),
      );
    }

    testWidgets('WT/ Displays loading indicator on load', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          const SearchResultsPage(searchTerm: 'test', isUserRegistered: true),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Initial search term appears in search field', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          const SearchResultsPage(searchTerm: 'laptop', isUserRegistered: true),
        ),
      );
      await tester.pump();
      final textField = find.byType(TextField);
      final textWidget = tester.widget<TextField>(textField);
      expect(textWidget.controller?.text, equals('laptop'));
    });

    test('generateErrorMessage formats correctly', () {
      expect(generateErrorMessage('404'), 'Failed to load results: 404');
    });

    test('getNoResultsMessage formats correctly', () {
      expect(getNoResultsMessage('TV'), 'No results found for "TV"');
    });

    test('shouldShowSearchButton returns false on empty input', () {
      expect(shouldShowSearchButton('  '), false);
    });

    test('shouldShowSearchButton returns true on valid input', () {
      expect(shouldShowSearchButton('keyboard'), true);
    });

    test('isValidSearch returns false for too short input', () {
      expect(isValidSearch('a'), false);
    });

    test('isImageAvailable returns false for empty string', () {
      expect(isImageAvailable(''), false);
    });

    test('calculateGridCrossAxisCount returns correct value', () {
      expect(calculateGridCrossAxisCount(500), equals(2));
      expect(calculateGridCrossAxisCount(700), equals(4));
    });

    test('hasError returns true if "fail" is in message', () {
      expect(hasError('Failed to load'), isTrue);
    });
  });
}
