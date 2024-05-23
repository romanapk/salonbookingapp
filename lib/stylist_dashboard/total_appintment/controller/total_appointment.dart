// import 'package:salonbookingapp/general/consts/consts.dart';
//
// class TotalAppointmentcontroller extends GetxController {
//   var docName = ''.obs;
//
//   Future<QuerySnapshot<Map<String, dynamic>>> getPendingAppointments() async {
//     return FirebaseFirestore.instance
//         .collection('appointments')
//         .where('appWith', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
//         .where('status', isEqualTo: 'pending')
//         .get();
//   }
//
//   Future<void> updateAppointmentStatus(
//       String appointmentId, String status) async {
//     await FirebaseFirestore.instance
//         .collection('appointments')
//         .doc(appointmentId)
//         .update({'status': status});
//   }
//
//   Future<QuerySnapshot<Map<String, dynamic>>> getConfirmedAppointments() async {
//     return FirebaseFirestore.instance
//         .collection('appointments')
//         .where('appWith', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
//         .where('status', isEqualTo: 'accepted')
//         .get();
//   }
// }
