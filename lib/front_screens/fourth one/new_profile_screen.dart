import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for date formatting

class UserProfileScreen extends StatelessWidget {
  // User data (replace with your data source)
  final String name = "John Doe";
  final String email = "johndoe@example.com";
  final String phone = "(555) 555-5555";
  final DateTime birthday =
      DateTime(1990, 1, 1); // Replace with user's birthday

  // Edit profile button (optional)
  Widget _editProfileButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Handle edit profile navigation
        Navigator.pushNamed(
            context, '/editProfile'); // Replace with your edit route
      },
      child: Text('Edit Profile'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: TextStyle(color: Colors.white), // Set app bar text color
        ),
        backgroundColor: Colors.teal, // Set a custom app bar color
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Stack(
                // Use Stack for profile picture with border
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(
                        'https://placeholdit.img/200x200'), // Replace with user's profile picture URL (optional)
                  ),
                  Positioned(
                    // Add a white border around the avatar
                    bottom: 0.0,
                    right: 0.0,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 2.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              name,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal, // Set a custom color for name
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              email,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20.0),
            Divider(
                thickness: 1.0, color: Colors.grey[300]), // Style the divider
            SizedBox(height: 20.0),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.teal), // Set icon color
              title: Text(phone),
            ),
            Divider(thickness: 1.0, color: Colors.grey[300]),
            ListTile(
              leading: Icon(Icons.cake, color: Colors.teal), // Set icon color
              title: Text(DateFormat('y MMMM d')
                  .format(birthday)), // Formatted birthday
            ),
            SizedBox(height: 20.0),
            _editProfileButton(context), // Add edit button if needed
          ],
        ),
      ),
    );
  }
}
