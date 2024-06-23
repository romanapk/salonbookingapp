import '../../../customer_dashboard/bottombar_screen.dart';
import '../../../general/consts/consts.dart';

class LoginController extends GetxController {
  UserCredential? userCredential;
  var isLoading = false.obs;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  //login if user enters valid email and password
  loginUser(context) async {
    if (formkey.currentState!.validate()) {
      try {
        isLoading(true);
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        isLoading(false);

        if (userCredential != null) {
          final uid = userCredential?.user!.uid;
          print('User signed in with UID: $uid');

          // Check if the user's account is approved in the 'stylists' collection
          var stylistSnapshot = await FirebaseFirestore.instance
              .collection('stylists')
              .doc(uid)
              .get();

          if (stylistSnapshot.exists) {
            var stylistData = stylistSnapshot.data() as Map<String, dynamic>;
            print('Stylist data: $stylistData');
            if (stylistData['status'] == 'approved') {
              // Stylist account is approved, allow login
              Get.offAll(() => AdminHomeScreen());
              VxToast.show(context, msg: "Login Successful");
              return;
            }
          }

          // Check if the user is in the 'acceptedStylists' collection
          var acceptedStylistSnapshot = await FirebaseFirestore.instance
              .collection('acceptedStylists')
              .doc(uid)
              .get();

          if (acceptedStylistSnapshot.exists) {
            var acceptedStylistData =
                acceptedStylistSnapshot.data() as Map<String, dynamic>;
            print('Accepted Stylist data: $acceptedStylistData');
            if (acceptedStylistData['status'] == 'approved') {
              // Accepted Stylist account is approved, allow login
              Get.offAll(() => AdminHomeScreen());
              VxToast.show(context, msg: "Login Successful");
              return;
            } else {
              VxToast.show(context, msg: "Your account is pending approval");
            }
          } else {
            print('Accepted stylist document not found for UID: $uid');
            VxToast.show(context, msg: "Account not found");
          }
        } else {
          VxToast.show(context, msg: "Login Failed");
        }
      } catch (e) {
        isLoading(false);
        print('Error during login: $e');
        VxToast.show(context, msg: "Wrong email or password");
      }
    }
  }

  //validate email and password
  String? validateemail(value) {
    if (value!.isEmpty) {
      return 'Please enter an email';
    }
    RegExp emailRefExp = RegExp(r'^[\w\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRefExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validpass(value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    RegExp emailRefExp = RegExp(r'^.{8,}$');
    if (!emailRefExp.hasMatch(value)) {
      return 'Password must contain at least 8 characters';
    }
    return null;
  }
}
