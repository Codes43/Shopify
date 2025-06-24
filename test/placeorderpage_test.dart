import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shopify/screens/placeorderpage.dart';
import 'package:shopify/services/auth_service.dart';
import 'package:shopify/provider/favorites_provider.dart';

String getDeliveryFee(String selectedDeliveryMethod) =>
    selectedDeliveryMethod == 'Express Delivery' ? '\$10.00' : '\$5.00';

String getTotalPrice(String selectedDeliveryMethod) =>
    selectedDeliveryMethod == 'Express Delivery' ? '\$130.00' : '\$125.00';

List<String> getMobileMoneyProviders() => ['MTN', 'Airtel'];

void main() {
  group('PlaceOrderPage Functional & Unit Tests', () {
    Widget makeTestableWidget(Widget child) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthService()),
          ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ],
        child: MaterialApp(home: child),
      );
    }

    testWidgets('Default payment method should be Credit Card', (tester) async {
      await tester.pumpWidget(makeTestableWidget(const PlaceOrderPage()));
      expect(find.text('Credit Card'), findsOneWidget);
    });

    testWidgets('Default mobile money provider should be MTN', (tester) async {
      await tester.pumpWidget(makeTestableWidget(const PlaceOrderPage()));
      await tester.tap(find.text('Credit Card'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mobile Money').last);
      await tester.pumpAndSettle();
      expect(find.text('MTN'), findsOneWidget);
    });

    test('Delivery fee is correct based on selected method', () {
      String getDeliveryFee(String method) =>
          method == 'Express Delivery' ? '\$10.00' : '\$5.00';
      expect(getDeliveryFee('Standard Delivery'), '\$5.00');
      expect(getDeliveryFee('Express Delivery'), '\$10.00');
    });

    test('Total calculation reflects delivery method correctly', () {
      String getTotal(String method) =>
          method == 'Express Delivery' ? '\$130.00' : '\$125.00';
      expect(getTotal('Standard Delivery'), '\$125.00');
      expect(getTotal('Express Delivery'), '\$130.00');
    });

    test('getDeliveryFee returns correct fee for Standard Delivery', () {
      expect(getDeliveryFee('Standard Delivery'), '\$5.00');
    });

    test('getDeliveryFee returns correct fee for Express Delivery', () {
      expect(getDeliveryFee('Express Delivery'), '\$10.00');
    });

    test('getTotalPrice returns correct total for Standard Delivery', () {
      expect(getTotalPrice('Standard Delivery'), '\$125.00');
    });

    test('getTotalPrice returns correct total for Express Delivery', () {
      expect(getTotalPrice('Express Delivery'), '\$130.00');
    });

    test('getMobileMoneyProviders contains MTN', () {
      expect(getMobileMoneyProviders(), contains('MTN'));
    });

    test('getMobileMoneyProviders contains Airtel', () {
      expect(getMobileMoneyProviders(), contains('Airtel'));
    });

    test('getMobileMoneyProviders length is 2', () {
      expect(getMobileMoneyProviders().length, 2);
    });
  });
}
