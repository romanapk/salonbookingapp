import 'package:salonbookingapp/general/consts/consts.dart';

class CustomerTotalAppointmentController extends GetxController {
  var docName = ''.obs;

  Future<QuerySnapshot<Map<String, dynamic>>> getConfirmedAppointments() async {
    return FirebaseFirestore.instance
        .collection('appointments')
        .where('appBy', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where('status', isEqualTo: 'accepted')
        .get();
  }
}
