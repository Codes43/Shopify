import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/models/product_model.dart';
import 'package:shopify/provider/cartprovider.dart';
import 'package:shopify/provider/favorites_provider.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductDetails> {
  int quantity = 1;
  bool isAddedToCart = false;

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  Future<void> addToCart(Product product, BuildContext context) async {
    try {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      await cartProvider.addToCart(product);
      setState(() {
        isAddedToCart = true;
      });

      // Show success message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Item added to cart')));

      // Optional: Navigate to cart screen
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const ShoppingCartScreen(),
      //     fullscreenDialog: true,
      //   ),
      // );
    } catch (error) {
      print('Error adding to cart: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add item to cart')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(widget.product);

    void toggleFavorite() {
      favoritesProvider.toggleFavorite(widget.product);
    }
    // When adding a product to cart:

  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              SizedBox(
                height: 300, // Fixed height to prevent unbounded constraints
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      widget.product.imageUrl.isNotEmpty
                          ? Image.network(
                            widget.product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 50),
                          )
                          : const Icon(Icons.image_not_supported, size: 50),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.bookmark : Icons.bookmark_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: toggleFavorite,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'UGX ${widget.product.price}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                widget.product.description,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 24),

              // Quantity Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: decreaseQuantity,
                  ),
                  Text(
                    quantity.toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: increaseQuantity,
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        isAddedToCart
                            ? null
                            : () => addToCart(widget.product, context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isAddedToCart ? 'Added to Cart' : 'Add to cart',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
