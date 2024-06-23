import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class StylistController extends GetxController {
  void rateStylist(String stylistId, double rating) async {
    try {
      await FirebaseFirestore.instance.collection('ratings').add({
        'stylistId': stylistId,
        'rating': rating,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Calculate average rating and update stylist profile
      var ratings = await FirebaseFirestore.instance
          .collection('ratings')
          .where('stylistId', isEqualTo: stylistId)
          .get();

      double totalRating = 0.0;
      int count = 0;

      for (var doc in ratings.docs) {
        totalRating += doc['rating'];
        count++;
      }

      double averageRating = totalRating / count;

      await FirebaseFirestore.instance
          .collection('stylists')
          .doc(stylistId)
          .update({
        'averageRating': averageRating,
      });

      // Notify stylist about the new rating
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': stylistId,
        'message': 'You received a new rating.',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error rating stylist: $e');
    }
  }
}
