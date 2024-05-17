import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController updatedNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              updateProfile();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: updatedNameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            // Add other fields as needed
          ],
        ),
      ),
    );
  }

  void updateProfile() async {
    try {
      // Get the current user ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Update the user document in Firestore
      await FirebaseFirestore.instance
          .collection("stylists")
          .doc(userId)
          .update({
        "stylistsName": updatedNameController.text.trim(),
        // Add other fields and their updated values
      });

      // Show a success message or navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
        ),
      );

      // You can also navigate back or perform other actions after updating
      // Example: Navigator.pop(context);
    } catch (error) {
      // Handle any errors that occur during the update process
      print("Error updating profile: $error");
    }
  }
}
