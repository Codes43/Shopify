import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'homepage.dart';
import 'profilescreen.dart';

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
  List<String> searchResults = [];

  final List<String> imageUrls = [
    'https://i.imgur.com/L68FtMA.jpg',
    'https://i.imgur.com/YKLRmF4.jpg',
    'https://i.imgur.com/w1UJZ2E.jpg',
    'https://i.imgur.com/xXGxO1J.jpg',
    'https://i.imgur.com/7LqXx4P.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _fetchSearchResults();
  }

  Future<void> _fetchSearchResults() async {
    await Future.delayed(Duration(seconds: 2));

    List<String> mockData = List.generate(
      10,
      (index) => '${widget.searchTerm} Item ${index + 1}',
    );

    setState(() {
      searchResults = mockData;
      isLoading = false;
    });
  }

  Widget buildProductCard(String title, String price, String imageUrl) {
    return Container(
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
          Expanded(child: Image.network(imageUrl, fit: BoxFit.contain)),
          SizedBox(height: 8),
          Text(
            price,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Container(
              height: 91,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.searchTerm,
                              style: TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Grid Area
            Expanded(
              child:
                  isLoading
                      ? Center(child: CircularProgressIndicator())
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
                          final title = searchResults[index];
                          final price =
                              '\$${(40 + index * 3.5).toStringAsFixed(2)}';
                          final imageUrl = imageUrls[index % imageUrls.length];

                          return buildProductCard(title, price, imageUrl);
                        },
                      ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
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
