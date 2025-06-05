import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'searchresultspage.dart'; // Ensure this import is valid

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bool isUserRegistered = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(91),
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                left: screenWidth * (33 / 390),
                top: 35,
                child: Text(
                  'Shopifty',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inria Sans',
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                left: screenWidth * (330.06 / 390),
                top: 39.37,
                child: IconButton(
                  icon: Icon(Icons.shopping_cart, color: Colors.black),
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
      body: Padding(
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
                    color: Colors.black,
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
                      width: 72,
                      height: 72,
                      iconSize: 28,
                    ),
                    SizedBox(width: 12),
                    _buildCategoryTile(
                      Icons.chair_alt,
                      'Chairs',
                      width: 72,
                      height: 72,
                      iconSize: 28,
                    ),
                    SizedBox(width: 12),
                    _buildCategoryTile(
                      Icons.table_bar,
                      'Tables',
                      width: 72,
                      height: 72,
                      iconSize: 28,
                    ),
                    SizedBox(width: 12),
                    _buildCategoryTile(
                      Icons.weekend,
                      'Sofas',
                      width: 72,
                      height: 72,
                      iconSize: 28,
                    ),
                    SizedBox(width: 12),
                    _buildCategoryTile(
                      Icons.bed,
                      'Beds',
                      width: 72,
                      height: 72,
                      iconSize: 28,
                    ),
                  ],
                ),
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

// Placeholder Profile Page
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Profile')),
      body: Center(child: Text('This is the Profile page')),
    );
  }
}
