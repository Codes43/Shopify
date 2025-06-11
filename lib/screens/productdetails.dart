import 'package:flutter/material.dart';
import 'package:shopify/models/product_model.dart';

// Import your Product model

class ProductDetails extends StatefulWidget {
  final Product product;
  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductDetails> {
  bool isFavorite = false;
  int quantity = 1;
  bool isAddedToCart = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

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

  void addToCart() {
    setState(() {
      isAddedToCart = true;
    });

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product added to cart!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 24),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Center(
                    child:
                        widget.product.imageUrl.isNotEmpty
                            ? Image.network(
                              widget.product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Icon(
                                    Icons.broken_image,
                                    size: 50,
                                  ), // Placeholder for broken image
                            )
                            : Icon(Icons.image_not_supported, size: 50),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'NEW',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.product.name,
                    style: TextStyle(
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
              'UGX  ${widget.product.price}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 24),
            Text(
              widget.product.description,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 100,
              ), // Equal left and right padding
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isAddedToCart ? null : addToCart,
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
          ],
        ),
      ),
    );
  }
}
