import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'searchresultspage.dart'; // Make sure this import exists
import 'profilescreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Container(
          color: Colors.white,
          child: Stack(
            
            children: [
              
              Positioned(
                
                left: screenWidth * (33 / 390),
                top: 40,
                child: Text(
                  'Shopify',
                  style:GoogleFonts.inriaSans(fontSize: 30,fontWeight: FontWeight.bold)
                ),
              ),
              Positioned(
                left: screenWidth * (330.06 / 390),
                top: 40,
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
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

      body: Column(
        

        children: [
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Color.fromRGBO(158, 158, 158, 1)),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search Product...',
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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
                    child: SvgPicture.asset(
           'assets/filter.svg',
           color: Colors.white,
           
           height: 70,
           width: 70,
         ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),


      //bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,

        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        elevation:0 ,
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

