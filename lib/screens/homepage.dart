import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shopify/provider/cartprovider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopify/provider/favorites_provider.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:shopify/screens/ShoppingCartScreen.dart';
import 'package:shopify/screens/productdetails.dart';
import 'package:shopify/models/product_model.dart'; // Import your Product model
import 'package:shopify/services/product_service.dart';
import 'package:shopify/services/auth_service.dart';
import 'package:shopify/screens/profilescreen.dart';
import 'package:shopify/screens/bookmarkscreen.dart';

import 'loginpage.dart';
import 'searchresultspage.dart';
//badge

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bool isUserRegistered = false;
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Product>> _productsFuture;
  final ProductService _productService = ProductService();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();

    _productsFuture =
        _productService.getProducts(); // Initialize the future in initState of productts
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void toCart() {
    _searchController.dispose();
    super.dispose();
  }

void _fetchProductsForCategory(String category) {
  setState(() {
    _selectedCategory = category;
    _productsFuture = _productService.getProductsByCategory(category);
  });
}
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final cartProvider = Provider.of<CartProvider>(context); // Add this
    final isUserRegistered = authService.isAuthenticated;

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 246, 246),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(81.0),
        child: Container(
          color: Colors.black,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth < 600 ? 16.0 : 32.0,
            vertical: 16.0,
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shopify',
                  style: GoogleFonts.inriaSans(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                    badges.Badge(
                              badgeContent: Text('${cartProvider.itemCount}'),
                              child: IconButton(
                                icon: Icon(Icons.shopping_cart, color: Colors.white),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ShoppingCartScreen(),
                                      fullscreenDialog: true,
                                    ),
                                  );
                                },
                              ),
                            ),,
              ],
            ),
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _productsFuture = _productService.getProducts();
            });
            await _productsFuture;
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Search for Products',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                  
                    SizedBox(width: 12),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(FontAwesomeIcons.magnifyingGlass, color: Colors.white),
                        onPressed: () {
                          String searchTerm = _searchController.text.trim();
                          if (searchTerm.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => SearchResultsPage(
                                      searchTerm: searchTerm,
                                      isUserRegistered: isUserRegistered,
                                    ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    ],
              ),
              

                SizedBox(height: 20),
                SizedBox(
                  height:
                      screenWidth > 800
                          ? 36
                          : 100, // 36 for wide, 100 for mobile
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                          _buildCategoryTile(
                        Icons.star,
                        'All', // Changed 'Popular' to 'All' for general products
                        isSelected: _selectedCategory == 'All',
                        screenWidth: screenWidth,
                        onTap: () => _fetchProductsForCategory('All'),
                      ),
                      _buildCategoryTile(
                         FontAwesomeIcons.mobilePhone,
                        'Phones',
                        isSelected: _selectedCategory == 'Phones',
                        screenWidth: screenWidth,
                        onTap: () => _fetchProductsForCategory('Phones'),
                      ),
                      _buildCategoryTile(
                         Icons.live_tv,
                        'Electronics',
                        isSelected: _selectedCategory == 'Electronics',
                        screenWidth: screenWidth,
                        onTap: () => _fetchProductsForCategory('Electronics'),
                      ),
                      _buildCategoryTile(
                         Icons.coffee_maker,
                        'Appliances',
                        isSelected: _selectedCategory == 'Appliances',
                        screenWidth: screenWidth,
                        onTap: () => _fetchProductsForCategory('Appliances'),
                      ),
                      _buildCategoryTile(
                         Icons.laptop_mac,
                        'Computing',
                        isSelected: _selectedCategory == 'Computing',
                        screenWidth: screenWidth,
                        onTap: () => _fetchProductsForCategory('Computing'),
                      ),
                      _buildCategoryTile(
                         Icons.watch,
                        'Fashion',
                        isSelected: _selectedCategory == 'Fashion',
                        screenWidth: screenWidth,
                        onTap: () => _fetchProductsForCategory('Fashion'),
                      ),
                      _buildCategoryTile(
                        Icons.sports_esports,
                        'Gaming',
                        isSelected: _selectedCategory == 'Gaming',
                        screenWidth: screenWidth,
                        onTap: () => _fetchProductsForCategory('Gaming'),
                      ),
                      _buildCategoryTile(
                        Icons.chair,
                        'Furniture',
                        isSelected: _selectedCategory == 'Furniture',
                        screenWidth: screenWidth,
                        onTap: () => _fetchProductsForCategory('Furniture'),
                      ),
                      _buildCategoryTile(
                         
                       Icons.spa_outlined,
              
                        'Beauty',
                        isSelected: _selectedCategory == 'Beauty',
                        screenWidth: screenWidth,
                        onTap: () => _fetchProductsForCategory('Beauty'),
                      ),
                      _buildCategoryTile(
                        Icons.home , 
                        'Home',
                        isSelected: _selectedCategory == 'home',
                        screenWidth: screenWidth,
                        onTap: () => _fetchProductsForCategory('home'),
                      ),
                      _buildCategoryTile(
                        Icons.emoji_food_beverage , 
                        'Beverages',
                        isSelected: _selectedCategory == 'Beverages',
                        screenWidth: screenWidth,
                        onTap: () => _fetchProductsForCategory('Beverages'),
                      ),
                      _buildCategoryTile(
                        Icons.child_care , 
                        'Baby',
                        isSelected: _selectedCategory == 'Baby',
                        screenWidth: screenWidth,
                        onTap: () => _fetchProductsForCategory('Baby'),
                      ),
                      _buildCategoryTile(
                        FontAwesomeIcons.appleWhole , 
                        'Others ',
                        isSelected: _selectedCategory == 'others',
                        screenWidth: screenWidth,
                        onTap: () => _fetchProductsForCategory('others'),
                      ),
  
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: screenWidth > 800 ? 280 : 400,
                      autoPlay: true,
                      viewportFraction: 1.0,
                    ),
                    items:
                        imgList.map((image) {
                          return Builder(
                            builder: (context) {
                              return Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(horizontal: 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    screenWidth > 800 ? 12.0 : 15.0,
                                  ),
                                  color: Colors.grey[200],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    screenWidth > 800 ? 12.0 : 15.0,
                                  ),
                                  child: image,
                                ),
                              );
                            },
                          );
                        }).toList(),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Products",
                    style: GoogleFonts.inriaSans(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FutureBuilder<List<Product>>(
                    future: _productsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No products found.'));
                      } else {
                        final products = snapshot.data!;
                        return GridView.builder(
                          padding: EdgeInsets.only(top: 16),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: products.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    screenWidth > 800
                                        ? (screenWidth / 250).floor()
                                        : 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.75,
                              ),
                          itemBuilder:
                              (context, index) =>
                                  _buildProductGridItem(products[index]),
                        );
                      }
                    },
                  ),
           ] )
              ),
              ),
            ),),
        
      

      bottomNavigationBar: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          return BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HomePage()),
                  );
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => BookmarkPage()),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => isUserRegistered ? ProfilePage() : LoginPage(),
                    ),
                  );
                  break;
              }
            },
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: badges.Badge(
                  badgeContent: Text(
                    '${favoritesProvider.favorites.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  showBadge: favoritesProvider.favorites.isNotEmpty,
                  child: const Icon(Icons.bookmark_border),
                ),
                label: 'Bookmarks',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductGridItem(Product product) {
    //print('fetched products ${jsonEncode(product.imageUrl)}');
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
                                (context, error, stackTrace) => Icon(
                                  Icons.broken_image,
                                  size: 50,
                                ), // Placeholder for broken image
                          )
                          : Icon(
                            Icons.image_not_supported,
                            size: 50,
                          ), // No image available
                ),
              ),

              SizedBox(height: 8),
              Text(
                product.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'UGX ${product.formattedPrice}',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: const Color.fromARGB(255, 14, 91, 207),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTile(
    IconData icon,
    String label, {
    bool isSelected = false,
    required double screenWidth,
    required VoidCallback onTap,
  }) {
    bool isWideScreen = screenWidth > 800;

    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child:
          GestureDetector(
            onTap: onTap,
            child: isWideScreen
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
                      SizedBox(width: 8),
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
                    SizedBox(height: 6),
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

  List<Image> imgList = [
    Image.asset('assets/splash.png', fit: BoxFit.cover),

    Image.asset('assets/big_image.jpg', fit: BoxFit.cover),
  ];
}
