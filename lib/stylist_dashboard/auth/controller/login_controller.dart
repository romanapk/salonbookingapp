import 'package:salonbookingapp/customer_dashboard/bottombar_screen.dart';
import 'package:salonbookingapp/general/consts/consts.dart';

class LoginController extends GetxController {
  UserCredential? userCredential;
  var isLoading = false.obs;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  // Login if user enters valid email and password
  loginUser(BuildContext context) async {
    if (formkey.currentState!.validate()) {
      try {
        isLoading(true);
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        isLoading(false);

        if (userCredential != null) {
          final uid = userCredential?.user!.uid;
          print('User signed in with UID: $uid');

          // Check if the user's account is approved in either 'stylists' or 'acceptedStylists' collection
          var stylistSnapshot = await FirebaseFirestore.instance
              .collection('stylists')
              .doc(uid)
              .get();

          var acceptedStylistSnapshot = await FirebaseFirestore.instance
              .collection('acceptedStylists')
              .doc(uid)
              .get();

          if (stylistSnapshot.exists &&
              stylistSnapshot['status'] == 'approved') {
            // Stylist account is approved, allow login
            Get.offAll(
                () => AdminHomeScreen()); // Navigate to your desired screen
            VxToast.show(context, msg: "Login Successful");
            return;
          } else if (acceptedStylistSnapshot.exists &&
              acceptedStylistSnapshot['status'] == 'approved') {
            // Accepted Stylist account is approved, allow login
            Get.offAll(
                () => AdminHomeScreen()); // Navigate to your desired screen
            VxToast.show(context, msg: "Login Successful");
            return;
          } else {
            VxToast.show(context, msg: "Your account is pending approval");
          }
        } else {
          VxToast.show(context, msg: "Account not found");
        }
      } catch (e) {
        isLoading(false);
        print('Error during login: $e');
        VxToast.show(context, msg: "Wrong email or password");
      }
    }
  }

  // Validate email
  String? validateemail(String? value) {
    if (value!.isEmpty) {
      return 'Please enter an email';
    }
    RegExp emailRefExp = RegExp(r'^[\w\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRefExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Validate password
  String? validpass(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must contain at least 8 characters';
    }
    return null;
  }

  @override
  void dispose() {
    // Clean up controllers when not needed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
