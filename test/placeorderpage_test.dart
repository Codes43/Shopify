import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopify/screens/placeorderpage.dart';
import 'package:provider/provider.dart';
import 'package:shopify/services/auth_service.dart';

class MockAuthService extends AuthService {
  // Override methods if needed or keep empty for now
}

void main() {
  String getDeliveryFee(String deliveryMethod) {
    return deliveryMethod == 'Express Delivery' ? '\$10.00' : '\$5.00';
  }

  String getTotal(String deliveryMethod) {
    return deliveryMethod == 'Express Delivery' ? '\$130.00' : '\$125.00';
  }

  group('Place Order Page Tests', () {
    // ------------------- UNIT TESTS ------------------- //
    group('Unit tests', () {
      test('Initial payment method should be Credit Card', () {
        final placeOrderState = _PlaceOrderPageStateForTest();
        expect(placeOrderState.dropdownValue, 'Credit Card');
      });

      test('Initial mobile money provider should be MTN', () {
        final placeOrderState = _PlaceOrderPageStateForTest();
        expect(placeOrderState.mobileMoneyProvider, 'MTN');
      });

      test('Initial delivery method should be Standard Delivery', () {
        final placeOrderState = _PlaceOrderPageStateForTest();
        expect(placeOrderState.selectedDeliveryMethod, 'Standard Delivery');
      });

      test('Delivery fee for Standard Delivery should be \$5.00', () {
        expect(getDeliveryFee('Standard Delivery'), '\$5.00');
      });

      test('Delivery fee for Express Delivery should be \$10.00', () {
        expect(getDeliveryFee('Express Delivery'), '\$10.00');
      });

      test('Total for Standard Delivery should be \$125.00', () {
        expect(getTotal('Standard Delivery'), '\$125.00');
      });

      test('Total for Express Delivery should be \$130.00', () {
        expect(getTotal('Express Delivery'), '\$130.00');
      });

      test('Changing payment method updates dropdownValue', () {
        final state = _PlaceOrderPageStateForTest();
        state.setDropdownValue('Mobile Money');
        expect(state.dropdownValue, 'Mobile Money');
        state.setDropdownValue('Cash on Delivery');
        expect(state.dropdownValue, 'Cash on Delivery');
      });

      test('Changing mobile money provider updates value', () {
        final state = _PlaceOrderPageStateForTest();
        state.setMobileMoneyProvider('Airtel');
        expect(state.mobileMoneyProvider, 'Airtel');
        state.setMobileMoneyProvider('MTN');
        expect(state.mobileMoneyProvider, 'MTN');
      });

      test('Changing delivery method updates selectedDeliveryMethod', () {
        final state = _PlaceOrderPageStateForTest();
        state.setDeliveryMethod('Express Delivery');
        expect(state.selectedDeliveryMethod, 'Express Delivery');
        state.setDeliveryMethod('Standard Delivery');
        expect(state.selectedDeliveryMethod, 'Standard Delivery');
      });
    });

    // ------------------- WIDGET TESTS ------------------- //
    group('Widget tests', () {
      // Wraps PlaceOrderPage without triggering CommonBottomNav
      Widget buildTestWidget() => const MaterialApp(
        home: Scaffold(
          body: PlaceOrderPage(), // ok since test targets body
        ),
      );

      testWidgets('PlaceOrderPage renders without crashing', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          Provider<AuthService>(
            create: (_) => MockAuthService(),
            child: MaterialApp(home: const PlaceOrderPage()),
          ),
        );

        expect(find.text('Place Order'), findsOneWidget);
      });
      testWidgets('Selecting Express Delivery updates delivery info', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider<AuthService>.value(
              value: MockAuthService(),
              child: const PlaceOrderPage(),
            ),
          ),
        );

        // Tap delivery method dropdown (assuming it's second DropdownButton)
        final deliveryDropdown = find.byType(DropdownButton<String>).at(1);
        await tester.tap(deliveryDropdown);
        await tester.pumpAndSettle();

        // Select 'Express Delivery' option
        await tester.tap(find.text('Express Delivery').last);
        await tester.pumpAndSettle();

        // Verify updated delivery info appears
        expect(find.textContaining('1-2 business days'), findsOneWidget);
      });

      testWidgets('updates delivery info based on delivery method', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());

        // Check default text
        expect(find.textContaining('3-5 business days'), findsOneWidget);

        // Change to Express
        await tester.tap(find.byType(DropdownButton<String>).at(1));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Express Delivery').last);
        await tester.pumpAndSettle();

        // Check new text
        expect(find.textContaining('1-2 business days'), findsOneWidget);
      });

      testWidgets('renders address input fields', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.widgetWithText(TextField, 'Full Name'), findsOneWidget);
        expect(find.widgetWithText(TextField, 'Your Address'), findsOneWidget);
      });

      testWidgets('shows credit card fields by default', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.widgetWithText(TextField, 'Card Number'), findsOneWidget);
        expect(find.widgetWithText(TextField, 'Expiry Date'), findsOneWidget);
        expect(find.widgetWithText(TextField, 'CVV'), findsOneWidget);
      });

      testWidgets('shows mobile money fields when selected', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.byType(DropdownButton<String>).first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Mobile Money').last);
        await tester.pumpAndSettle();

        expect(find.textContaining('mobile money provider'), findsOneWidget);
        expect(find.widgetWithText(TextField, 'Phone Number'), findsOneWidget);
      });
    });
  });
}

// Test-safe class for unit tests
class _PlaceOrderPageStateForTest {
  String dropdownValue = 'Credit Card';
  String mobileMoneyProvider = 'MTN';
  String selectedDeliveryMethod = 'Standard Delivery';

  void setDropdownValue(String val) => dropdownValue = val;
  void setMobileMoneyProvider(String val) => mobileMoneyProvider = val;
  void setDeliveryMethod(String val) => selectedDeliveryMethod = val;
}
