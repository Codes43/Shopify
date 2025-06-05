import 'package:flutter/material.dart';



  class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // User Profile Image
           
                   Image.asset(
                    "assets/user.png", 
                    fit: BoxFit.cover,
                    width: 160,
                    height: 160,
                  
                  ),
                
            
              

              // Username
              Text(
                "Shopify1",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),

              // Email
              Text("shopify@gmail.com",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 40),

               ElevatedButton(
                
                    style: ElevatedButton.styleFrom(
                      
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () { 
                       print('Login pressed');

                    },

                    child: Container(
                      width: 100,

                      child: Row(

                        children: [
                          
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.logout,),
                          ),
                          Text('Logout',style: TextStyle(),),
                        ],
                      ),
                    ),
                  ),
             
            ],
          ),
        ),
      ),
    );
  }
}
