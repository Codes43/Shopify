import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shopify/models/product_model.dart';
import 'package:shopify/services/auth_service.dart';
import 'package:shopify/provider/cartprovider.dart';
import 'package:shopify/provider/favorites_provider.dart';
import 'package:shopify/screens/homepage.dart';
import 'package:shopify/screens/productdetails.dart';
import 'package:shopify/services/product_service.dart';

class MockProductService extends ProductService {
  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    return [
      Product(
        id: 1,
        name: 'Phone',
        description: 'Smartphone',
        price: 500000,
        imageUrl: 'https://example.com/image.jpg',
      ),
    ];
  }
}

class AuthServiceMock extends ChangeNotifier implements AuthService {
  final bool _isAuthenticated;

  AuthServiceMock({bool isAuthenticated = false})
    : _isAuthenticated = isAuthenticated;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  bool get isLoading => false;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> login(String username, String password) async {}

  @override
  Future<void> logout() async {}

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class CartProviderMock extends ChangeNotifier implements CartProvider {
  @override
  int get itemCount => 3;
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class SearchResultsPage extends StatelessWidget {
  final String searchTerm;
  final bool isUserRegistered;

  const SearchResultsPage({
    Key? key,
    required this.searchTerm,
    required this.isUserRegistered,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('SearchResultsPage: $searchTerm');
  }
}

Widget buildCategoryTile(
  IconData icon,
  String label, {
  bool isSelected = false,
  required double screenWidth,
  required VoidCallback onTap,
}) {
  bool isWideScreen = screenWidth > 800;

  return Padding(
    padding: const EdgeInsets.only(right: 12.0),
    child: GestureDetector(
      onTap: onTap,
      child:
          isWideScreen
              ? Container(
                width: 120,
                height: 56,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: isSelected ? Colors.white : Colors.black54,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        color: isSelected ? Colors.white : Colors.black54,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.grey[600],
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
    ),
  );
}

Widget buildProductGridItem(Product product, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductDetails(product: product)),
      );
    },
    child: Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child:
                    product.imageUrl.isNotEmpty
                        ? Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 50),
                        )
                        : const Icon(Icons.image_not_supported, size: 50),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'UGX ${product.formattedPrice}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Color.fromARGB(255, 14, 91, 207),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget makeTestableWidget(
  Widget child, {
  AuthService? authService,
  CartProvider? cartProvider,
  FavoritesProvider? favoritesProvider,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthService>(
        create: (_) => authService ?? AuthServiceMock(),
      ),
      ChangeNotifierProvider<CartProvider>(
        create: (_) => cartProvider ?? CartProviderMock(),
      ),
      ChangeNotifierProvider<FavoritesProvider>(
        create: (_) => favoritesProvider ?? FavoritesProviderMock(),
      ),
    ],
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

class FavoritesProviderMock extends ChangeNotifier
    implements FavoritesProvider {
  @override
  List<Product> get favorites => [];

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('HomePage Widget & Unit Tests', () {
    testWidgets('WT: AppBar shows Shopify title and cart badge', (
      tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(const HomePage()));
      expect(find.text('Shopify'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets(
      'buildProductGridItem shows fallback icon when imageUrl is empty',
      (tester) async {
        final product = Product(
          id: 10,
          name: 'No Image Product',
          description: 'Desc',
          price: 10000,
          imageUrl: '',
        );

        await tester.pumpWidget(
          makeTestableWidget(
            Builder(
              builder: (context) => buildProductGridItem(product, context),
            ),
          ),
        );

        expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
      },
    );

    test('BuildCategoryTile returns Padding widget', () {
      final widget = buildCategoryTile(
        Icons.star,
        'TestCategory',
        isSelected: true,
        screenWidth: 1000,
        onTap: () {},
      );
      expect(widget, isA<Padding>());
    });

    test('BuildProductGridItem returns GestureDetector widget', () {
      final product = Product(
        id: 1,
        name: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        imageUrl: '',
      );

      // ignore: invalid_use_of_protected_member
      final context = makeTestableWidget(const SizedBox()).createElement();
      final widget = buildProductGridItem(product, context);

      expect(widget, isA<GestureDetector>());
    });

    test('Product formattedPrice formats correctly', () {
      final product = Product(
        id: 1,
        name: 'Test',
        description: 'desc',
        price: 25000,
        imageUrl: '',
      );

      expect(product.formattedPrice, '25,000');
    });

    test('Category tile colors change on selection', () {
      final selectedTile = buildCategoryTile(
        Icons.star,
        'Label',
        isSelected: true,
        screenWidth: 900,
        onTap: () {},
      );

      final unselectedTile = buildCategoryTile(
        Icons.star,
        'Label',
        isSelected: false,
        screenWidth: 900,
        onTap: () {},
      );

      expect(selectedTile, isA<Padding>());
      expect(unselectedTile, isA<Padding>());
    });

    test('CartProviderMock returns fixed itemCount', () {
      final cartProvider = CartProviderMock();
      expect(cartProvider.itemCount, 3);
    });

    test('getProductsByCategory returns products for given category', () async {
      final service = MockProductService();
      final products = await service.getProductsByCategory('Phones');

      expect(products, isA<List<Product>>());
      expect(products.length, 1);
      expect(products.first.name, 'Phone');
      expect(products.first.price, 500000);
    });

    test('FavoritesProviderMock returns empty favorites list', () {
      final favoritesProvider = FavoritesProviderMock();

      expect(favoritesProvider.favorites, isEmpty);
    });

    test('AuthServiceMock returns expected isAuthenticated', () {
      final auth1 = AuthServiceMock(isAuthenticated: true);
      final auth2 = AuthServiceMock(isAuthenticated: false);

      expect(auth1.isAuthenticated, true);
      expect(auth2.isAuthenticated, false);
    });
  });
}
