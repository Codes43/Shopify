import 'package:flutter/material.dart';
import 'package:shopify/screens/productdetails.dart';
import 'loginpage.dart';
import 'homepage.dart';
import 'profilescreen.dart';
import 'package:shopify/models/product_model.dart';
import 'package:shopify/services/product_service.dart';

class SearchResultsPage extends StatefulWidget {
  final String searchTerm;
  final bool isUserRegistered;

  const SearchResultsPage({
    super.key,
    required this.searchTerm,
    required this.isUserRegistered,
  });

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  bool isLoading = true;
  List<Product> searchResults = [];
  String errorMessage = '';
  final ProductSearchService _productSearchService = ProductSearchService();
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchTerm);
    _fetchSearchResults();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchSearchResults([String? newTerm]) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      final results = await _productSearchService.searchProducts(
        newTerm ?? widget.searchTerm,
      );
      setState(() {
        searchResults = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load results: $e';
      });
    }
  }

  Widget buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetails(product: product)),
        );
      }, child:  Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child:
                product.imageUrl.isNotEmpty
                    ? Image.network(
                      product.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              Icon(Icons.broken_image, size: 50),
                    )
                    : Icon(Icons.image_not_supported, size: 50),
          ),
          SizedBox(height: 8),
        
          SizedBox(height: 4),
          Text(
            product.name,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 56,
              margin: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 4),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      size: 22,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          _fetchSearchResults(value.trim());
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.white70, size: 20),
                    onPressed: () {
                      final value = _searchController.text.trim();
                      if (value.isNotEmpty) {
                        _fetchSearchResults(value);
                      }
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child:
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : errorMessage.isNotEmpty
                      ? Center(child: Text(errorMessage))
                      : searchResults.isEmpty
                      ? Center(
                        child: Text(
                          'No results found for "${widget.searchTerm}"',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                      : GridView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: searchResults.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 3 / 4,
                        ),
                        itemBuilder: (context, index) {
                          final product = searchResults[index];
                          return buildProductCard(product);
                        },
                      ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomePage()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => BookmarkPage()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (_) =>
                          widget.isUserRegistered ? ProfilePage() : LoginPage(),
                ),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
