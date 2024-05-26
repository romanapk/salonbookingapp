import '../../../customer_dashboard/bottombar_screen.dart';
import '../../../general/consts/consts.dart';
class LoginController extends GetxController {
  UserCredential? userCredential;
  var isLoading = false.obs;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  //login if user enter validate email and password
  loginUser(context) async {
    if (formkey.currentState!.validate()) {
      try {
        isLoading(true);
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        isLoading(false);
        // Check if user credentials are valid
        if (userCredential != null) {
          // Check if the user's account is approved
          var snapshot = await FirebaseFirestore.instance
              .collection('stylists')
              .doc(userCredential!.user!.uid)
              .get();
          if (snapshot.exists) {
            var stylistData = snapshot.data() as Map<String, dynamic>;
            if (stylistData['status'] == 'approved') {
              // Stylist account is approved, allow login
              Get.offAll(() => AdminHomeScreen());
              VxToast.show(context, msg: "Login Successful");
            } else {
              // Stylist account is not approved yet
              VxToast.show(context, msg: "Your account is pending approval");
            }
          } else {
            VxToast.show(context, msg: "Account not found");
          }
        } else {
          VxToast.show(context, msg: "Login Failed");
        }
      } catch (e) {
        isLoading(false);
        VxToast.show(context, msg: "Wrong email or password");
      }
    }
  }

  //validate email and password
  String? validateemail(value) {
    if (value!.isEmpty) {
      return 'please enter an email';
    }
    RegExp emailRefExp = RegExp(r'^[\w\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRefExp.hasMatch(value)) {
      return 'please enter a valid email';
    }
    return null;
  }

  String? validpass(value) {
    if (value!.isEmpty) {
      return 'please enter a password';
    }
    RegExp emailRefExp = RegExp(r'^.{8,}$');
    if (!emailRefExp.hasMatch(value)) {
      return 'Password Must Contain At Least 8 Characters';
    }
    return null;
  }
}