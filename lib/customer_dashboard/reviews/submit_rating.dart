import 'package:cloud_firestore/cloud_firestore.dart';

void submitRating(
    String stylistId, String customerId, int rating, String review) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Add rating to 'ratings' collection
    await firestore.collection('ratings').add({
      'stylistId': stylistId,
      'customerId': customerId,
      'rating': rating,
      'review': review,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Calculate average rating
    QuerySnapshot querySnapshot = await firestore
        .collection('ratings')
        .where('stylistId', isEqualTo: stylistId)
        .get();

    List<DocumentSnapshot> ratings = querySnapshot.docs;
    double averageRating = 0;

    if (ratings.isNotEmpty) {
      int totalRatings = ratings.length;
      int totalStars = ratings
          .map((rating) => rating['rating'] as int)
          .reduce((a, b) => a + b);
      averageRating = totalStars / totalRatings;
    }

    // Update 'stylists' document with averageRating
    await firestore.collection('stylists').doc(stylistId).update({
      'averageRating': averageRating,
    });

    // Optionally, send notification to stylist (using Firebase Cloud Messaging)
    // Implement notification logic here

    print('Rating submitted successfully');
  } catch (e) {
    print('Error submitting rating: $e');
  }
}
