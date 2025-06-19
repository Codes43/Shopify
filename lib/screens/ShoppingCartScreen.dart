import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/provider/cartprovider.dart';
import 'package:shopify/screens/placeorderpage.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  double subtotal = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    await cartProvider.loadCartItems();

    setState(() {
      subtotal = cartProvider.cartItems.fold(
        0,
        (sum, item) => sum + (item.price * item.quantity),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Shopping Cart',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Items selected - ${cartItems.length} items',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),

            // Cart Items List
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Dismissible(
                    key: Key('${item.id}'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) async {
                      await cartProvider.removeItem(item.id);
                      _loadCartItems();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${item.name} removed from cart'),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 1,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(9),
                        child: Row(
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 168, 167, 167),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child:
                                  item.imageUrl.isNotEmpty
                                      ? Image.network(
                                        item.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.broken_image,
                                                  size: 50,
                                                ),
                                      )
                                      : const Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                      ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const SizedBox(height: 4),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                          0,
                                          0,
                                          5,
                                          0,
                                        ),

                                        child: Text(
                                          '${(item.price * item.quantity).toStringAsFixed(2)} UGX',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),

                                      Row(
                                        children: [
                                          Container(
                                            height: 25, // Exact height
                                            width:
                                                25, // Optional: Set width if needed
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    5,
                                                  ), // Corner radius
                                            ),
                                            child: IconButton(
                                              padding:
                                                  EdgeInsets
                                                      .zero, // Remove default padding
                                              constraints: BoxConstraints(),
                                              style: IconButton.styleFrom(
                                                backgroundColor: Colors.black,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              icon: const Icon(Icons.remove),
                                              onPressed: () async {
                                                if (item.quantity > 1) {
                                                  await cartProvider
                                                      .updateItemQuantity(
                                                        item.id,
                                                        item.quantity - 1,
                                                      );
                                                  _loadCartItems();
                                                }
                                              },
                                            ),
                                          ),

                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                              5,
                                              0,
                                              5,
                                              0,
                                            ),
                                            child: Text(
                                              item.quantity.toString(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),

                                          Container(
                                            height: 25, // Exact height
                                            width:
                                                25, // Optional: Set width if needed
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    5,
                                                  ), // Corner radius
                                            ),
                                            child: IconButton(
                                              icon: const Icon(Icons.add),
                                              padding:
                                                  EdgeInsets
                                                      .zero, // Remove default padding
                                              constraints: BoxConstraints(),
                                              style: IconButton.styleFrom(
                                                backgroundColor: Colors.black,
                                                foregroundColor: Colors.white,
                                                minimumSize: Size(7, 7),
                                              ),
                                              onPressed: () async {
                                                await cartProvider
                                                    .updateItemQuantity(
                                                      item.id,
                                                      item.quantity + 1,
                                                    );
                                                _loadCartItems();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Cart Summary
            const Divider(height: 24),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 200, 202, 198),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Cart Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal:'),
                      Text(
                        '${subtotal.toStringAsFixed(2)} UGX',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Checkout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlaceOrderPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'CheckOut',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
