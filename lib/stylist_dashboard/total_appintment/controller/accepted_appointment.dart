import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AcceptedAppointmentController extends GetxController {
  var acceptedAppointments = <DocumentSnapshot>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAcceptedAppointments();
  }

  void fetchAcceptedAppointments() {
    FirebaseFirestore.instance
        .collection('appointments')
        .where('appWith', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where('status', isEqualTo: 'accepted')
        .snapshots()
        .listen((data) {
      acceptedAppointments.value = data.docs;
    });
  }

  Future<void> cancelAppointment(
      String appointmentId, BuildContext context) async {
    try {
      var appointmentDoc = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .get();
      var customerUid = appointmentDoc['appBy'];

      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({'status': 'cancelled'});

      // Notify the customer about the cancellation
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': customerUid,
        'message':
            'Your appointment on ${appointmentDoc['appDay']} at ${appointmentDoc['appTime']} has been cancelled. You can reschedule it.',
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment cancelled and customer notified.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel appointment: $e')),
      );
    }
  }
}
