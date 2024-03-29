import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../admin_dashboard/widgets/loading_dialog.dart';
import '../admin_dashboard/widgets/progress_bar.dart';
import '../colors/app_colors.dart';

class DoctorProfileSetupScreen extends StatefulWidget {
  const DoctorProfileSetupScreen({Key? key}) : super(key: key);

  @override
  _DoctorProfileSetupScreenState createState() =>
      _DoctorProfileSetupScreenState();
}

class _DoctorProfileSetupScreenState extends State<DoctorProfileSetupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController doctorNameController = TextEditingController();
  TextEditingController specializationController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController selectedWorkingDaysController = TextEditingController();
  TextEditingController workingHoursController = TextEditingController();
  TextEditingController clinicNameController = TextEditingController();
  TextEditingController clinicPlaceController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Position? position;
  List<Placemark>? placeMarks;

  String sellerImageUrl = "";
  String completeAddress = "";

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {});
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

    clinicPlaceController.text = completeAddress;
  }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Please select an image."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      if (clinicPlaceController.text.isNotEmpty) {
        // start uploading image
        showDialog(
          context: context,
          builder: (c) {
            return const LoadingDialoge(
              message: "Setting up Stylist's Profile",
            );
          },
        );

        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        fStorage.Reference reference = fStorage.FirebaseStorage.instance
            .ref()
            .child("doctor_profiles")
            .child(fileName);
        fStorage.UploadTask uploadTask =
            reference.putFile(File(imageXFile!.path));
        fStorage.TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() {});
        await taskSnapshot.ref.getDownloadURL().then((url) {
          sellerImageUrl = url;

          // save info to firestore
          saveDoctorProfile();
        });
      } else {
        showDialog(
          context: context,
          builder: (c) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text(
                  "Please write the complete required info for Stylist's Profile."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> saveDoctorProfile() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection("stylists")
        .doc(currentUser!.uid)
        .set({
      "stylistName": doctorNameController.text.trim(),
      "specialization": specializationController.text.trim(),
      "qualification": qualificationController.text.trim(),
      "selectedWorkingDays": selectedWorkingDaysController.text.trim(),
      "workingHours": workingHoursController.text.trim(),
      "salonName": clinicNameController.text.trim(),
      "salonPlace": clinicPlaceController.text.trim(),
      "profileImageUrl": sellerImageUrl,
    });

    Navigator.pop(context);
    // navigate to doctor's dashboard or any other screen as needed
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: () {
              _getImage();
            },
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.13,
              backgroundColor: AppColors.baseColor,
              backgroundImage:
                  imageXFile == null ? null : FileImage(File(imageXFile!.path)),
              child: imageXFile == null
                  ? Icon(
                      Icons.add_photo_alternate,
                      size: MediaQuery.of(context).size.width * 0.10,
                      color: AppColors.whitColor,
                    )
                  : null,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.person,
                  controller: doctorNameController,
                  hintText: "Stylist's Name",
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.person,
                  controller: specializationController,
                  hintText: "Specialization",
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.person,
                  controller: qualificationController,
                  hintText: "Qualification",
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.calendar_today,
                  controller: selectedWorkingDaysController,
                  hintText: "Selected Working Days",
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.access_time,
                  controller: workingHoursController,
                  hintText: "Working Hours",
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.location_on,
                  controller: clinicNameController,
                  hintText: "Salon Name",
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.location_on,
                  controller: clinicPlaceController,
                  hintText: "Salon Place",
                  isObsecre: false,
                ),
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
                      backgroundColor: AppColors.darkerColor,
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.baseColor,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            ),
            onPressed: () {
              formValidation();
            },
            child: const Text(
              "Save Profile",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
