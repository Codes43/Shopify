// lib/screens/bookmarkscreen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/provider/favorites_provider.dart';
import 'package:shopify/screens/productdetails.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favorites = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorites'),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text('No bookmarked items yet'),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final product = favorites[index];
                return ListTile(
                  leading: product.imageUrl.isNotEmpty
                      ? Image.network(
                          product.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image_not_supported),
                  title: Text(product.name),
                  subtitle: Text('UGX ${product.price}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.bookmark, color: Colors.red),
                    onPressed: () => favoritesProvider.toggleFavorite(product),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetails(product: product),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}