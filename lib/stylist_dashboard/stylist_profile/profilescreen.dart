import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonbookingapp/stylist_dashboard/auth/controller/signup_controller.dart';

import 'editprofilescreen.dart';

class StylistProfileScreen extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());

  StylistProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // backgroundColor: Styles.bgColor,
          // title: Text("Profile"),
          // elevation: 0,
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.logout),
          //     onPressed: () async {
          //       await controller.signout();
          //       Get.offAllNamed('/login');
          //     },
          //   ),
          // ],
          ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('acceptedStylists')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text("No profile data found"));
            } else {
              var data = snapshot.data!.data() as Map<String, dynamic>;
              controller.nameController.text = data['stylistName'] ?? '';
              controller.phoneController.text = data['stylistPhone'] ?? '';
              controller.emailController.text = data['stylistEmail'] ?? '';
              controller.categoryController.text =
                  data['stylistCategory'] ?? '';
              controller.timeController.text = data['stylistTiming'] ?? '';
              controller.basePriceController.text = data['stylistAbout'] ?? '';
              controller.addressController.text = data['stylistAddress'] ?? '';
              controller.serviceController.text = data['stylistService'] ?? '';
              controller.profilePictureUrl.value = data['profilePicture'] ?? '';

              return Obx(() {
                return Column(
                  children: [
                    _buildProfileView(context, data),
                    const SizedBox(height: 20),
                    if (!controller.isEditing.value)
                      ElevatedButton(
                        onPressed: () {
                          Get.to(() => StylistEditProfileScreen());
                        },
                        child: const Text("Edit Profile"),
                      ),
                  ],
                );
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileView(BuildContext context, Map<String, dynamic> data) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(controller.profilePictureUrl.value),
        ),
        const SizedBox(height: 20),
        _buildProfileField(
          controller: controller.nameController,
          label: 'Name',
          readOnly: true,
        ),
        _buildProfileField(
          controller: controller.categoryController,
          label: 'Category',
          readOnly: true,
        ),
      ],
    );
  }

  Widget _buildProfileField({
    required TextEditingController controller,
    required String label,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}
