import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class PendingAppointmentController extends GetxController {
  var pendingAppointments = <DocumentSnapshot>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingAppointments();
  }

  void fetchPendingAppointments() {
    FirebaseFirestore.instance
        .collection('appointments')
        .where('appWith', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((data) {
      pendingAppointments.value = data.docs;
    });
  }

  Future<void> acceptAppointment(String appointmentId) async {
    try {
      var appointmentDoc = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .get();
      var customerUid = appointmentDoc['appBy'];

      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({'status': 'accepted'});

      // Notify the customer about the appointment confirmation
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': customerUid,
        'message':
            'Your appointment on ${appointmentDoc['appDay']} at ${appointmentDoc['appTime']} has been confirmed.',
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'confirmed',
      });
    } catch (e) {
      // Handle any errors
    }
  }

  Future<void> rejectAppointment(String appointmentId) async {
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(appointmentId)
        .delete();
  }
}
