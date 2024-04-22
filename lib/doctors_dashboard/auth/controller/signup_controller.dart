import '../../../admin_dashboard/bottombar_screen.dart';
import '../../../general/consts/consts.dart';

class SignupController extends GetxController {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var categoryController = TextEditingController();
  var timeController = TextEditingController();
  var aboutController = TextEditingController();
  var addressController = TextEditingController();
  var serviceController = TextEditingController();
  var stylistType = 'Stylist'.obs; // Observe stylist type (Stylist or Salon)
  var offersHomeService = false.obs; // Observe in-home service availability
  UserCredential?
      stylistCredential; // Use stylistCredential instead of userCredential
  var isLoading = false.obs;
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

  signupStylist(context) async {
    if (formkey.currentState!.validate()) {
      try {
        isLoading(true);
        stylistCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        if (stylistCredential != null) {
          var store = FirebaseFirestore.instance.collection(
              stylistType.value); // Use stylistType for collection path
          await store.doc(stylistCredential!.user!.uid).set({
            'stylistId': stylistCredential!.user!.uid,
            'stylistName': nameController.text,
            'stylistEmail': emailController.text,
            'stylistPassword': passwordController.text,
            'stylistAbout': aboutController.text,
            'stylistAddress': addressController.text,
            'stylistCategory': categoryController.text,
            'stylistPhone': phoneController.text,
            'stylistRating': '4', // Placeholder rating
            'stylistServices': serviceController.text,
            'stylistTiming': timeController.text,
            'offersHomeService':
                offersHomeService.value, // Add in-home service flag
            // Add location data if implemented (optional)
          });
          VxToast.show(context, msg: "Signup Successful");
          if (stylistType.value == 'Stylist') {
            Get.offAll(
                () => AdminHomeScreen()); // Navigate to appropriate screen
          } else {
            // Handle Salon signup navigation (if applicable)
          }
        }
        isLoading(false);
      } catch (e) {
        isLoading(false);
        // ... handle errors ...
      }
    }
  }

// class SignupController extends GetxController {
//   var nameController = TextEditingController();
//   var phoneController = TextEditingController();
//   var emailController = TextEditingController();
//   var passwordController = TextEditingController();
//   var categoryController = TextEditingController();
//   var timeController = TextEditingController();
//   var aboutController = TextEditingController();
//   var addressController = TextEditingController();
//   var serviceController = TextEditingController();
//   UserCredential? userCredential;
//   var isLoading = false.obs;
//   final GlobalKey<FormState> formkey = GlobalKey<FormState>();
//   RxString selectedValue = "Facial".obs;
//
//   void showDropdownMenu(BuildContext context) {
//     final List<PopupMenuEntry<String>> items = [
//       const PopupMenuItem(value: 'Facial', child: Text('Facial')),
//       const PopupMenuItem(value: 'Hair', child: Text('Hair')),
//       const PopupMenuItem(value: 'Spa', child: Text('Spa')),
//       const PopupMenuItem(value: 'Nail', child: Text('Nail')),
//       const PopupMenuItem(value: 'Makeup', child: Text('Makeup')),
//       const PopupMenuItem(value: 'Eye', child: Text('Eye')),
//     ];
//
//     showMenu(
//       context: context,
//       position: RelativeRect.fromRect(
//         Rect.fromPoints(
//           Offset.zero,
//           Offset.zero,
//         ),
//         Offset.zero & MediaQuery.of(context).size,
//       ),
//       items: items,
//     ).then((value) {
//       if (value != null) {
//         selectedValue.value = value;
//         categoryController.text = value;
//       }
//     });
//   }
//
//   signupUser(context) async {
//     if (formkey.currentState!.validate()) {
//       try {
//         isLoading(true);
//         userCredential =
//             await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: emailController.text,
//           password: passwordController.text,
//         );
//         if (userCredential != null) {
//           var store = FirebaseFirestore.instance
//               .collection('stylists')
//               .doc(userCredential!.user!.uid);
//           await store.set({
//             'stylistId': userCredential!.user!.uid,
//             'stylistName': nameController.text,
//             'stylistPassword': passwordController.text,
//             'stylistEmail': emailController.text,
//             'stylistAbout': aboutController.text,
//             'stylistAddress': addressController.text,
//             'stylistCategory': categoryController.text,
//             'stylistPhone': phoneController.text,
//             'stylistRating': '4',
//             'stylistService': serviceController.text,
//             'stylistTiming': timeController.text,
//           });
//           VxToast.show(context, msg: "Signup Sucessfull");
//         }
//         isLoading(false);
//       } catch (e) {
//         isLoading(false);
//         // Check the type of exception and show a toast accordingly
//         if (e is FirebaseAuthException) {
//           if (e.code == 'email-already-in-use') {
//             // The email address is already in use by another account
//             VxToast.show(context, msg: "Allready have an account");
//           } else {
//             // Handle other FirebaseAuth exceptions
//             VxToast.show(context, msg: "No internet connection");
//           }
//         } else {
//           // Handle other exceptions (not related to FirebaseAuth)
//           VxToast.show(context, msg: "Try after some time ");
//         }
//         log("$e");
//       }
//     }
//   }

  storeUserData(
      String uid, String fullname, String email, String password) async {
    var store = FirebaseFirestore.instance.collection('users').doc(uid);
    await store.set({
      'uid': uid,
      'fullname': fullname,
      'password': email,
      'email': password,
    });
  }

  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  //vlidateemail
  String? validateemail(value) {
    if (value!.isEmpty) {
      return 'please enter an email';
    }
    RegExp emailRefExp = RegExp(r'^[\w\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRefExp.hasMatch(value)) {
      return 'please enter a valied email';
    }
    return null;
  }

  //validate pass
  String? validpass(value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    // Check for at least one capital letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one capital letter';
    }
    // Check for at least one number
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    // Check for at least one special character
    if (!value.contains(RegExp(r'[!@#\$&*~]'))) {
      return 'Password must contain at least one special character (!@#\$&*~)';
    }
    // Check for overall pattern
    RegExp passwordRegExp =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (!passwordRegExp.hasMatch(value)) {
      return 'Your Password Must Contain At Least 8 Characters';
    }

    return null;
  }

  //validate name
  String? validname(value) {
    if (value!.isEmpty) {
      return 'please enter a password';
    }
    RegExp emailRefExp = RegExp(r'^.{5,}$');
    if (!emailRefExp.hasMatch(value)) {
      return 'Password enter a valid name';
    }
    return null;
  }

  String? validfield(value) {
    if (value!.isEmpty) {
      return 'please fil this document';
    }
    RegExp emailRefExp = RegExp(r'^.{2,}$');
    if (!emailRefExp.hasMatch(value)) {
      return 'please fil this document';
    }
    return null;
  }
}
