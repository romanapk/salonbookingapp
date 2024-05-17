import 'package:salonbookingapp/general/consts/consts.dart';

class AppointmentController extends GetxController {
  var isLoading = false.obs;
  var appDayController = TextEditingController();
  var appTimeController = TextEditingController();
  var appNameController = TextEditingController();
  var appMobileController = TextEditingController();
  var appMessageController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bookAppointment(String docId, String docName, String docNum, context) async {
    if (formkey.currentState!.validate()) {
      try {
        isLoading(true);
        var store = FirebaseFirestore.instance.collection('appointments').doc();
        await store.set({
          'appBy': FirebaseAuth.instance.currentUser?.uid,
          'appDay': appDayController.text,
          'appTime': appTimeController.text,
          'appName': appNameController.text,
          'appMobile': appMobileController.text,
          'appMsg': appMessageController.text,
          'appWith': docId,
          'appStylistName': docName,
          'appStylistNum': docNum,
          'isConfirmed': false, // Add the isConfirmed field here
        });
        isLoading(false);
        VxToast.show(context, msg: "Appointment is booked successfully");
        Get.back();
      } catch (e) {
        isLoading(false); // Ensure loading state is reset in case of error
        VxToast.show(context, msg: "$e");
      }
    }
  }

  String? validdata(value) {
    if (value!.isEmpty) {
      return 'please fill this';
    }
    RegExp emailRefExp = RegExp(r'^.{3,}$');
    if (!emailRefExp.hasMatch(value)) {
      return 'Enter valid data';
    }
    return null;
  }
}
