import 'package:flutter/material.dart';
import 'package:shopify/screens/profilescreen.dart'; // <-- ADD THIS (or wherever ProfilePage is located)
import 'package:shopify/screens/loginpage.dart';
import 'package:shopify/screens/homepage.dart';

class SearchResultsPage extends StatelessWidget {
  final String searchTerm;
  final bool isUserRegistered;

  SearchResultsPage({required this.searchTerm, required this.isUserRegistered});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Container(
              height: 91, // Set from Figma
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, size: 28),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: screenWidth * 0.02), // Figma-based spacing
                  Expanded(
                    child: Container(
                      height: 40, // from Figma
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
                              searchTerm,
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

            // Product List Area
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: 10, // Placeholder
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text('$searchTerm Product ${index + 1}'),
                      subtitle: Text('Description for product ${index + 1}'),
                      onTap: () {
                        // Product details logic
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar (reused)
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
}
