import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class SignupController extends GetxController {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var categoryController = TextEditingController();
  var timeController = TextEditingController();
  var basePriceController = TextEditingController();
  var addressController = TextEditingController();
  var serviceController = TextEditingController();
  UserCredential? userCredential;
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isEditing = false.obs;
  var profilePictureUrl = ''.obs;
  var certificateImageUrl = ''.obs;

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  RxString selectedValue = "Facial".obs;

  void showDropdownMenu(BuildContext context) {
    final List<PopupMenuEntry<String>> items = [
      const PopupMenuItem(value: 'Facial', child: Text('Facial')),
      const PopupMenuItem(value: 'Hair', child: Text('Hair')),
      const PopupMenuItem(value: 'Spa', child: Text('Spa')),
      const PopupMenuItem(value: 'Nail', child: Text('Nail')),
      const PopupMenuItem(value: 'Makeup', child: Text('Makeup')),
      const PopupMenuItem(value: 'Eye', child: Text('Eye')),
    ];

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          Offset.zero,
          Offset.zero,
        ),
        Offset.zero & MediaQuery.of(context).size,
      ),
      items: items,
    ).then((value) {
      if (value != null) {
        selectedValue.value = value;
        categoryController.text = value;
      }
    });
  }

  Future<void> pickCertificateImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      await uploadCertificateImage(File(image.path));
    }
  }

  Future<void> uploadCertificateImage(File imageFile) async {
    try {
      isLoading(true);
      String userId = FirebaseAuth.instance.currentUser!.uid;
      Reference storageReference =
          FirebaseStorage.instance.ref().child('certificates/$userId');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      certificateImageUrl.value = await taskSnapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('acceptedStylists')
          .doc(userId)
          .update({'certificateUrl': certificateImageUrl.value});
      Get.snackbar('Success', 'Certificate uploaded successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload certificate');
    } finally {
      isLoading(false);
    }
  }

  Future<void> signupUser(BuildContext context) async {
    if (formkey.currentState!.validate()) {
      try {
        isLoading(true);
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        if (userCredential != null) {
          var store = FirebaseFirestore.instance
              .collection('pendingStylists')
              .doc(userCredential!.user!.uid);
          await store.set({
            'stylistId': userCredential!.user!.uid,
            'stylistName': nameController.text,
            'stylistPassword': passwordController.text,
            'stylistEmail': emailController.text,
            'stylistAbout': basePriceController.text,
            'stylistAddress': addressController.text,
            'stylistCategory': categoryController.text,
            'stylistPhone': phoneController.text,
            'stylistRating': '4',
            'stylistService': serviceController.text,
            'stylistTiming': timeController.text,
            'status': 'pending',
          });
          VxToast.show(context, msg: "Your request has been sent");
        }
        isLoading(false);
      } catch (e) {
        isLoading(false);
        if (e is FirebaseAuthException) {
          if (e.code == 'email-already-in-use') {
            VxToast.show(context, msg: "Already have an account");
          } else {
            VxToast.show(context, msg: "No internet connection");
          }
        } else {
          VxToast.show(context, msg: "Try after some time ");
        }
        log("$e");
      }
    }
  }

  Future<void> storeUserData(
      String uid, String fullname, String email, String password) async {
    var store = FirebaseFirestore.instance.collection('users').doc(uid);
    await store.set({
      'uid': uid,
      'fullname': fullname,
      'password': email,
      'email': password,
    });
  }

  Future<void> signout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      await uploadImage(File(image.path));
    }
  }

  Future<void> uploadImage(File imageFile) async {
    try {
      isLoading(true);
      String userId = FirebaseAuth.instance.currentUser!.uid;
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_pictures/$userId');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      profilePictureUrl.value = await taskSnapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('acceptedStylists')
          .doc(userId)
          .update({'profilePicture': profilePictureUrl.value});
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image');
    } finally {
      isLoading(false);
    }
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Please enter an email';
    }
    RegExp emailRegExp = RegExp(r'^[\w\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validateField(String? value) {
    if (value!.isEmpty) {
      return 'Please fill this field';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a name';
    }
    return null;
  }

  String? validpass(value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one capital letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!value.contains(RegExp(r'[!@#\$&*~]'))) {
      return 'Password must contain at least one special character (!@#\$&*~)';
    }
    RegExp passwordRegExp =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (!passwordRegExp.hasMatch(value)) {
      return 'Your Password Must Contain At Least 8 Characters';
    }
    return null;
  }

  String? validfield(value) {
    if (value!.isEmpty) {
      return 'please fill this document';
    }
    RegExp emailRefExp = RegExp(r'^.{2,}$');
    if (!emailRefExp.hasMatch(value)) {
      return 'please fill this document';
    }
    return null;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleEdit() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value) {
      resetControllers();
    }
  }

  void resetControllers() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    categoryController.clear();
    timeController.clear();
    basePriceController.clear();
    addressController.clear();
    serviceController.clear();
  }
}
