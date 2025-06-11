import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shopify/screens/productdetails.dart';
import 'loginpage.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'searchresultspage.dart';

import 'package:shopify/models/product_model.dart'; // Import your Product model
import 'package:shopify/services/product_service.dart';
import 'searchresultspage.dart';
import 'package:shopify/services/auth_service.dart';
import 'package:shopify/models/product_model.dart'; // Import your Product model
import 'package:shopify/services/product_service.dart';
import 'package:shopify/screens/profilescreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bool isUserRegistered = false;
  final TextEditingController _searchController = TextEditingController();

  late Future<List<Product>> _productsFuture; // Declare a Future for products
  final ProductService _productService =
      ProductService(); // Instantiate your service

  @override
  void initState() {
    super.initState();
    _productsFuture =
        _productService.getProducts(); // Initialize the future in initState
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final isUserRegistered = authService.isAuthenticated;

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 246, 246),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(81),

        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                left: screenWidth * (33 / 390),
                top: 45,
                child: Text(
                  'Shopify',

                  style: GoogleFonts.inriaSans(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                left: screenWidth * (330.06 / 390),
                top: 45,
                child: IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: const Color.fromARGB(255, 14, 13, 13),
                  ),
                  iconSize: 24.3,
                  onPressed: () {
                    print('To Carts Page!');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Color.fromRGBO(158, 158, 158, 1),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search for furniture',
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
                      color: const Color.fromARGB(255, 158, 153, 153),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.tune, color: Colors.white),
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
                height: 100,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryTile(
                        Icons.star,
                        'Popular',
                        isSelected: true,
                        width: 62,
                        height: 62,
                        iconSize: 35,
                      ),
                      SizedBox(width: 12),
                      _buildCategoryTile(
                        Icons.chair_alt,
                        'Chairs',
                        width: 62,
                        height: 62,
                        iconSize: 35,
                      ),
                      SizedBox(width: 12),
                      _buildCategoryTile(
                        Icons.table_bar,
                        'Tables',
                        width: 62,
                        height: 62,
                        iconSize: 35,
                      ),
                      SizedBox(width: 12),
                      _buildCategoryTile(
                        Icons.weekend,
                        'Sofas',
                        width: 62,
                        height: 62,
                        iconSize: 35,
                      ),
                      SizedBox(width: 12),
                      _buildCategoryTile(
                        Icons.weekend,
                        'Sofas',
                        width: 62,
                        height: 62,
                        iconSize: 35,
                      ),
                      SizedBox(width: 12),
                      _buildCategoryTile(
                        Icons.bed,
                        'Beds',
                        width: 62,
                        height: 62,
                        iconSize: 35,
                      ),
                    ],
                  ),
                ),
              ),

              // carousel_sliderfor ADS
              CarouselSlider(
                options: CarouselOptions(
                  height: 300.0,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  pauseAutoPlayOnTouch: true,

                  viewportFraction: 1.0,
                ),
                items:
                    imgList.map((image) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(26, 100, 98, 98),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                15.0,
                              ), // Apply the same border radius here
                              child: image, // This is your Image.asset widget
                            ),
                          );
                        },
                      );
                    }).toList(),
              ),
              SizedBox(height: 5.0),
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
                    return Center(
                      child: Text(
                        'Error loading products: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No products found.'));
                  } else {
                    final int itemCount = snapshot.data!.length;
                    // Assuming 2 items per row
                    final int numRows = (itemCount / 2).ceil();
                    // (width / 2) * 0.75 (for aspectRatio) + mainAxisSpacing
                    final double itemHeight =
                        (MediaQuery.of(context).size.width / 2) * 0.75;
                    final double gridHeight =
                        (numRows * itemHeight) +
                        ((numRows - 1) * 16); // 16 is mainAxisSpacing

                    return SizedBox(
                      // Use SizedBox to give the GridView a bounded height
                      height: gridHeight, // Dynamically calculate height
                      child: GridView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: itemCount,
                        shrinkWrap:
                            true, // Crucial: GridView will only take up needed space
                        physics:
                            NeverScrollableScrollPhysics(), // Crucial: Disable GridView's own scrolling
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          Product product = snapshot.data![index];
                          return _buildProductGridItem(product);
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),

      //bottom nav
      bottomNavigationBar: BottomNavigationBar(
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

  Widget _buildProductGridItem(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetails(product: product)),
        );
      },
      child: Card(
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
              SizedBox(height: 4),

              // Text(
              //   product.description,
              //   style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              //   maxLines: 2,
              //   overflow: TextOverflow.ellipsis,
              // ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '\UGX ${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: const Color.fromARGB(255, 13, 35, 236),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // category class
  List imgList = [
    Image.asset(
      'assets/splash.png',
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/images (1).jpg',
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/images (2).jpg',
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/images.jpg',
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    ),
  ];

  Widget _buildCategoryTile(
    IconData icon,
    String label, {
    bool isSelected = false,
    double width = 64,
    double height = 64,
    double iconSize = 28,
    double borderRadius = 16,
  }) {
    return Column(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Center(
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black54,
              size: iconSize,
            ),
          ),
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

// Placeholder Bookmark Page
class BookmarkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bookmarks')),
      body: Center(child: Text('This is the Bookmark page')),
    );
  }
}
