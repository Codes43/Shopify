import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'loginpage.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: PreferredSize(
        
        preferredSize: Size.fromHeight(81),
        
        child: Container(
          color: Colors.black,
          
          child: Stack(
            
            children: [
              Positioned(
                left: screenWidth * (33 / 390),
                top: 45,
                child: Text(
                  'Shopify',
                  style: GoogleFonts.inriaSans(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold)
                ),
              ),
              Positioned(
                left: screenWidth * (330.06 / 390),
                top: 45,
                child: IconButton(
                  icon: Icon(Icons.shopping_cart, color: Colors.white),
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
        
    options: CarouselOptions(height: 300.0,  
    autoPlay: true,             
    autoPlayInterval: Duration(seconds: 3),  
    autoPlayAnimationDuration: Duration(milliseconds: 800),  
    autoPlayCurve: Curves.fastOutSlowIn,     
    pauseAutoPlayOnTouch: true,
    
    viewportFraction: 1.0,   ),
  items: imgList.map((image) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height:300,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(26, 100, 98, 98),
            borderRadius: BorderRadius.circular(15.0),
            
          ),
          child: image, 
        );
      },
    );
  }).toList(),
),
SizedBox(height: 5.0,),
Text("Products",style: GoogleFonts.inriaSans(color: Colors.black,fontSize: 28, fontWeight: FontWeight.bold),)
          ],
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



  // category class
  List imgList = [
    Image.asset('assets/user.png'),
    Image.asset('assets/splash.png'),
    Image.asset('assets/user.png'),
    Image.asset('assets/splash.png'),
   
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
 