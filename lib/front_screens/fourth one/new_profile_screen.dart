import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for date formatting

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // User data (replace with your data source)
  final String name = "John Doe";
  final String email = "johndoe@example.com";
  final String phone = "(555) 555-5555";
  final DateTime birthday =
      DateTime(1990, 1, 1); // Replace with user's birthday

  // Edit profile button (optional)
  Widget _editProfileButton() {
    return TextButton.icon(
      onPressed: () {
        // Handle edit profile navigation
        Navigator.pushNamed(
            context, '/editProfile'); // Replace with your edit route
      },
      icon: Icon(Icons.edit),
      label: Text('Edit Profile'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(
                    'https://placeholdit.img/200x200'), // Replace with user's profile picture URL (optional)
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              name,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
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
            SizedBox(height: 10.0),
            Divider(),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Icon(Icons.phone),
                SizedBox(width: 10.0),
                Text(phone),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Icon(Icons.cake),
                SizedBox(width: 10.0),
                Text(DateFormat('y MMMM d')
                    .format(birthday)), // Formatted birthday
              ],
            ),
            SizedBox(height: 20.0),
            _editProfileButton(), // Add edit button if needed
          ],
        ),
      ),
    );
  }
}
