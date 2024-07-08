import 'package:salonbookingapp/general/consts/consts.dart';

class StylistPasswordResetPage extends StatefulWidget {
  const StylistPasswordResetPage({Key? key}) : super(key: key);

  @override
  _StylistPasswordResetPageState createState() =>
      _StylistPasswordResetPageState();
}

class _StylistPasswordResetPageState extends State<StylistPasswordResetPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      VxToast.show(context, msg: "Password reset email sent to your email");
      Get.back();
    } catch (error) {
      print("Error sending password reset email: $error");
      // Handle password reset email sending error
    }
  }

  Future<void> updatePasswordInFirestore(User user, String newPassword) async {
    try {
      String userId = user.uid;
      CollectionReference users =
          FirebaseFirestore.instance.collection('acceptedStylists');
      await users.doc(userId).update({'password': newPassword});
      // Password in Firestore updated successfully
      // Handle navigation or show a success message
    } catch (error) {
      print("Error updating password in Firestore: $error");
      // Handle Firestore update error
    }
  }

  Future<void> handlePasswordReset() async {
    String email = emailController.text;
    String newPassword = newPasswordController.text;

    try {
      // Send password reset email
      await resetPassword(email);

      // Wait for the user to reset their password using the email link

      // Get the current user after password reset
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Update the password in Firestore
        await updatePasswordInFirestore(user, newPassword);
      }
    } catch (error) {
      // Handle password reset and Firestore update errors
      print("Error handling password reset: $error");
      // Show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stylist Password Reset'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            30.heightBox,
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_rounded),
                labelText: 'Enter your Email',
                border: OutlineInputBorder(borderSide: BorderSide()),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.key),
                labelText: 'Enter New Password',
                border: OutlineInputBorder(borderSide: BorderSide()),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primeryColor,
                shape: const StadiumBorder(),
              ),
              onPressed: () => handlePasswordReset(),
              child: const Text(
                'Reset Password',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
