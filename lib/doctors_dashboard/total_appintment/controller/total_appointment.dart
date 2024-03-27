import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class TotalAppointmentcontroller extends GetxController {
  var docName = ''.obs;
  Future<QuerySnapshot<Map<String, dynamic>>> getAppointments() async {
    return FirebaseFirestore.instance
        .collection('appointments')
        .where(
          'appBy',
          isEqualTo: FirebaseAuth.instance.currentUser?.uid,
        )
        .get();
  }
}
