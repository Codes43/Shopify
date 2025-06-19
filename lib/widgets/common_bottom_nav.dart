import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shopify/provider/favorites_provider.dart';
import 'package:shopify/screens/homepage.dart';
import 'package:shopify/screens/bookmarkscreen.dart';
import 'package:shopify/screens/profilescreen.dart';
import 'package:shopify/screens/loginpage.dart';
import 'package:shopify/services/auth_service.dart';

class CommonBottomNav extends StatelessWidget {
  final int currentIndex;

  const CommonBottomNav({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final isUserRegistered = authService.isAuthenticated;

    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        return BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          currentIndex: currentIndex,
          onTap: (index) {
            if (index == currentIndex) return;
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
                    builder: (_) => isUserRegistered ? ProfilePage() : LoginPage(),
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
    );
  }
}