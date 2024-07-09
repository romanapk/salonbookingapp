import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonbookingapp/Utils/app_style.dart';
import 'package:salonbookingapp/stylist_dashboard/auth/controller/signup_controller.dart';

class StylistEditProfileScreen extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());

  StylistEditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.bgColor,
        title: Text("Edit Profile"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                controller.basePriceController.text =
                    data['stylistAbout'] ?? '';
                controller.addressController.text =
                    data['stylistAddress'] ?? '';
                controller.serviceController.text =
                    data['stylistService'] ?? '';
                controller.profilePictureUrl.value =
                    data['profilePicture'] ?? '';

                return Obx(() {
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(controller.profilePictureUrl.value),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await controller.pickImage();
                        },
                        child: const Text("Update Profile Picture"),
                      ),
                      const SizedBox(height: 20),
                      _buildProfileField(
                        controller: controller.nameController,
                        label: 'Name',
                        readOnly: true,
                      ),
                      _buildProfileField(
                        controller: controller.phoneController,
                        label: 'Phone',
                      ),
                      _buildProfileField(
                        controller: controller.emailController,
                        label: 'Email',
                        readOnly: true,
                      ),
                      _buildProfileField(
                        controller: controller.categoryController,
                        label: 'Category',
                      ),
                      _buildProfileField(
                        controller: controller.timeController,
                        label: 'Available Time',
                      ),
                      _buildProfileField(
                        controller: controller.basePriceController,
                        label: 'Base Price',
                      ),
                      _buildProfileField(
                        controller: controller.addressController,
                        label: 'Address',
                      ),
                      _buildProfileField(
                        controller: controller.serviceController,
                        label: 'Services',
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await _updateProfile();
                        },
                        child: const Text("Save"),
                      ),
                    ],
                  );
                });
              }
            },
          ),
        ),
      ),
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

  Future<void> _updateProfile() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('acceptedStylists')
        .doc(userId)
        .update({
      'stylistPhone': controller.phoneController.text,
      'stylistCategory': controller.categoryController.text,
      'stylistTiming': controller.timeController.text,
      'stylistAbout': controller.basePriceController.text,
      'stylistAddress': controller.addressController.text,
      'stylistService': controller.serviceController.text,
      'profilePicture': controller.profilePictureUrl.value,
    });
    Get.back();
  }
}

Future<void> createStylistProfile(Map<String, dynamic> data) async {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance
      .collection('acceptedStylists')
      .doc(userId)
      .set({
    ...data,
    'feedbacks': [],
    'averageRating': 0,
  });
}
