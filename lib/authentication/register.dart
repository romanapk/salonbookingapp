import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/app_style.dart';
import '../front_screens/app_shell.dart';
import '../global/global.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';
import 'my_button.dart';
import 'my_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Position? position;
  List<Placemark>? placeMarks;

  String sellerImageUrl = "";
  String completeAddress = "";

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  getCurrentLocation() async {
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    position = newPosition;

    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );

    Placemark pMark = placeMarks![0];

    completeAddress =
        '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    locationController.text = completeAddress;
  }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
        context: context,
        builder: (c) {
          return const ErrorDialoge(
            message: "Please select an image.",
          );
        },
      );
    } else {
      if (passwordController.text == confirmPasswordController.text) {
        if (confirmPasswordController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            nameController.text.isNotEmpty &&
            phoneController.text.isNotEmpty &&
            locationController.text.isNotEmpty) {
          showDialog(
            context: context,
            builder: (c) {
              return const LoadingDialoge(
                message: "Registering Account",
              );
            },
          );

          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          fStorage.Reference reference = fStorage.FirebaseStorage.instance
              .ref()
              .child("salon users")
              .child(fileName);
          fStorage.UploadTask uploadTask =
              reference.putFile(File(imageXFile!.path));
          fStorage.TaskSnapshot taskSnapshot =
              await uploadTask.whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            sellerImageUrl = url;

            authenticateSellerAndSignUp();
          });
        } else {
          showDialog(
            context: context,
            builder: (c) {
              return const ErrorDialoge(
                message:
                    "Please write the complete required info for Registration.",
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialoge(
              message: "Password do not match.",
            );
          },
        );
      }
    }
  }

  void authenticateSellerAndSignUp() async {
    User? currentUser;

    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialoge(
            message: error.message.toString(),
          );
        },
      );
    });

    if (currentUser != null) {
      saveDataToFirestore(currentUser!).then((value) {
        Navigator.pop(context);
        //send user to homePage
        Route newRoute = MaterialPageRoute(
          builder: (c) => const AppShell(),
        );
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future<void> saveDataToFirestore(User currentUser) async {
    try {
      await FirebaseFirestore.instance
          .collection("salon user detail")
          .doc(currentUser.uid)
          .set({
        "salonID": currentUser.uid,
        "salonEmail": currentUser.email,
        "salonName": nameController.text.trim(),
        "salonAvatarUrl": sellerImageUrl,
        "phone": phoneController.text.trim(),
        "address": completeAddress,
        "status": "approved",
        "earnings": 0.0,
        "lat": position!.latitude,
        "lng": position!.longitude,
      });

      // Save data locally
      sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences!.setString("uid", currentUser.uid);
      await sharedPreferences!.setString("email", currentUser.email.toString());
      await sharedPreferences!.setString("name", nameController.text.trim());
      await sharedPreferences!.setString("photoUrl", sellerImageUrl);
    } catch (error) {
      print("Error saving data to Firestore: $error");
      // Handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () {
                _getImage();
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.15,
                backgroundColor: Styles.orangeColor,
                backgroundImage: imageXFile == null
                    ? null
                    : FileImage(File(imageXFile!.path)),
                child: imageXFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: MediaQuery.of(context).size.width * 0.18,
                        color: Styles.textColor,
                      )
                    : null,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  MyTextField(
                    data: Icons.person,
                    controller: nameController,
                    hintText: 'Username',
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),

                  MyTextField(
                    data: Icons.email,
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  //
                  //
                  // CustomTextField(
                  //   data: Icons.email,
                  //   controller: emailController,
                  //   hintText: "Email",
                  //   isObsecre: false,
                  // ),

                  const SizedBox(height: 15),
                  MyTextField(
                    data: Icons.lock,
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  //
                  // CustomTextField(
                  //   data: Icons.lock,
                  //   controller: passwordController,
                  //   hintText: "Password",
                  //   isObsecre: true,
                  // ),

                  const SizedBox(height: 15),
                  MyTextField(
                    data: Icons.lock,
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    obscureText: true,
                  ),

                  // CustomTextField(
                  //   data: Icons.lock,
                  //   controller: confirmPasswordController,
                  //   hintText: "Confirm Password",
                  //   isObsecre: true,
                  // ),

                  const SizedBox(height: 15),
                  MyTextField(
                    data: Icons.phone,
                    controller: phoneController,
                    hintText: "Phone",
                    obscureText: false,
                  ),

                  // CustomTextField(
                  //   data: Icons.phone,
                  //   controller: phoneController,
                  //   hintText: "Phone",
                  //   isObsecre: false,
                  // ),

                  const SizedBox(height: 15),
                  MyTextField(
                    data: Icons.my_location,
                    controller: locationController,
                    hintText: "Salon Location",
                    obscureText: true,
                    enabled: true,
                  ),
                  //
                  // CustomTextField(
                  //   data: Icons.my_location,
                  //   controller: locationController,
                  //   hintText: "Salon Location",
                  //   isObsecre: false,
                  //   enabled: true,
                  // ),
                  const SizedBox(height: 15),

                  Container(
                    width: 400,
                    height: 40,
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      label: const Text(
                        "Get my Current Location",
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Geolocator.requestPermission();
                        getCurrentLocation();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.darkColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              // style: ElevatedButton.styleFrom(
              //   backgroundColor: Styles.bgColor, // Background color
              //   padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              // ),
              onTap: () {
                formValidation();
              },
              text: "Sign Up",
              // style: TextStyle(
              //   color: Styles.textColor, // Text color
              //   fontWeight: FontWeight.bold,
              // ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
