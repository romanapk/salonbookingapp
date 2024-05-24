import 'package:salonbookingapp/general/consts/consts.dart';

class CustomerTotalAppointmentController extends GetxController {
  var confirmedAppointments = <DocumentSnapshot>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchConfirmedAppointments();
  }

  void fetchConfirmedAppointments() {
    FirebaseFirestore.instance
        .collection('appointments')
        .where('appBy', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where('status', isEqualTo: 'accepted')
        .snapshots()
        .listen((data) {
      confirmedAppointments.value = data.docs;
    });
  }

  Future<void> cancelAppointment(
      String appointmentId, BuildContext context) async {
    try {
      var appointmentDoc = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .get();
      var stylistUid = appointmentDoc['appWith'];

      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({'status': 'cancelled'});

      // Notify the stylist about the cancellation
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': stylistUid,
        'message':
            'The appointment with ${appointmentDoc['appName']} on ${appointmentDoc['appDay']} at ${appointmentDoc['appTime']} has been cancelled by the customer.',
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment cancelled and stylist notified.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel appointment: $e')),
      );
    }
  }
}
