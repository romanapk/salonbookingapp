// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class StylistProfileScreen extends StatelessWidget {
//   final String stylistId;
//
//   const StylistProfileScreen({Key? key, required this.stylistId})
//       : super(key: key);
//
//   // Function to submit rating to Firestore
//   Future<void> submitRating(String stylistId, int rating) async {
//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//     try {
//       // Add rating to 'ratings' collection
//       await firestore.collection('ratings').add({
//         'stylistId': stylistId,
//         'rating': rating,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//       // Calculate average rating and update 'stylists' document
//       QuerySnapshot querySnapshot = await firestore
//           .collection('ratings')
//           .where('stylistId', isEqualTo: stylistId)
//           .get();
//
//       List<DocumentSnapshot> ratings = querySnapshot.docs;
//       double averageRating = 0;
//
//       if (ratings.isNotEmpty) {
//         int totalRatings = ratings.length;
//         int totalStars = ratings
//             .map((rating) => rating['rating'] as int)
//             .reduce((a, b) => a + b);
//         averageRating = totalStars / totalRatings;
//       }
//
//       // Update 'stylists' document with averageRating
//       await firestore.collection('stylists').doc(stylistId).update({
//         'averageRating': averageRating,
//       });
//
//       // Optionally, send notification to stylist (using Firebase Cloud Messaging)
//       // Implement notification logic here
//
//       print('Rating submitted successfully');
//     } catch (e) {
//       print('Error submitting rating: $e');
//       throw e; // Throw the error to handle it in the UI if needed
//     }
//   }
//
//   // Function to fetch reviews for a stylist
//   Future<List<DocumentSnapshot>> getReviews(String stylistId) async {
//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//     try {
//       QuerySnapshot querySnapshot = await firestore
//           .collection('reviews')
//           .where('stylistId', isEqualTo: stylistId)
//           .get();
//
//       return querySnapshot.docs;
//     } catch (e) {
//       print('Error fetching reviews: $e');
//       return []; // Return an empty list or handle the error
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Stylist Profile'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Display stylist details (name, category, etc.)
//             StreamBuilder<DocumentSnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('stylists')
//                   .doc(stylistId)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//
//                 var stylistData = snapshot.data!.data() as Map<String, dynamic>;
//                 var stylistName = stylistData['stylistName'];
//                 var stylistCategory = stylistData['stylistCategory'];
//                 var averageRating = stylistData['averageRating'] ?? 0.0;
//
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Stylist: $stylistName',
//                       style: TextStyle(
//                           fontSize: 20.0, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 8.0),
//                     Text(
//                       'Category: $stylistCategory',
//                       style: TextStyle(fontSize: 18.0),
//                     ),
//                     SizedBox(height: 8.0),
//                     Text(
//                       'Average Rating: ${averageRating.toStringAsFixed(1)}',
//                       style: TextStyle(fontSize: 18.0),
//                     ),
//                     SizedBox(height: 16.0),
//
//                     // Option to rate the stylist
//                     Text(
//                       'Rate this stylist:',
//                       style: TextStyle(fontSize: 18.0),
//                     ),
//                     SizedBox(height: 8.0),
//                     Slider(
//                       value: averageRating.toDouble(),
//                       min: 0,
//                       max: 5,
//                       divisions: 5,
//                       label: averageRating.toString(),
//                       onChanged: (newRating) {
//                         // Update rating in Firestore
//                         submitRating(stylistId, newRating.toInt());
//                       },
//                     ),
//
//                     SizedBox(height: 16.0),
//
//                     // Option to leave a review
//                     ElevatedButton(
//                       onPressed: () {
//                         // Navigate to review screen or implement review functionality
//                         // Replace with your navigation logic or UI for leaving a review
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     ReviewScreen(stylistId: stylistId)));
//                       },
//                       child: Text('Give Feedback'),
//                     ),
//
//                     SizedBox(height: 16.0),
//
//                     // Button to see all reviews
//                     ElevatedButton(
//                       onPressed: () {
//                         // Navigate to see all reviews screen or implement functionality
//                         // Replace with your navigation logic or UI for seeing all reviews
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     AllReviewsScreen(stylistId: stylistId)));
//                       },
//                       child: Text('See All Reviews'),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Example screen to leave a review
// class ReviewScreen extends StatelessWidget {
//   final String stylistId;
//
//   const ReviewScreen({Key? key, required this.stylistId}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Leave a Review'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Review Screen for Stylist ID: $stylistId'),
//             // Add your UI elements for leaving a review here
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Example screen to see all reviews
// class AllReviewsScreen extends StatelessWidget {
//   final String stylistId;
//
//   const AllReviewsScreen({Key? key, required this.stylistId}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('All Reviews'),
//       ),
//       body: FutureBuilder<List<DocumentSnapshot>>(
//         future: StylistProfileScreen(
//           stylistId: '',
//         ).getReviews(stylistId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No reviews found'));
//           }
//
//           List<DocumentSnapshot> reviews = snapshot.data!;
//
//           return ListView.builder(
//             itemCount: reviews.length,
//             itemBuilder: (context, index) {
//               var reviewData = reviews[index].data() as Map<String, dynamic>;
//               var rating = reviewData['rating'];
//               var reviewText = reviewData['review'];
//
//               return ListTile(
//                 title: Text('Rating: $rating'),
//                 subtitle: Text('Review: $reviewText'),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Add this package

// Add Firebase Messaging for notifications
import '../../../Utils/app_style.dart';
import '../../../general/consts/consts.dart';
import 'all_reviews/all_reviews_screen.dart';

class StylistProfile extends StatefulWidget {
  final DocumentSnapshot doc;
  const StylistProfile({Key? key, required this.doc}) : super(key: key);

  @override
  _StylistProfileState createState() => _StylistProfileState();
}

class _StylistProfileState extends State<StylistProfile> {
  double currentRating = 0.0;
  TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var stylistData = widget.doc.data() as Map<String, dynamic>;
    double averageRating = stylistData['stylistRating']?.toDouble() ?? 0.0;
    int ratingCount = stylistData['ratingCount']?.toInt() ?? 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.bgColor,
        title: Text("Stylist's details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.bgDarkColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.hardEdge,
                      height: 75,
                      width: 75,
                      child: Image.asset(
                        AppAssets.imgLogin,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stylistData['stylistName'],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            stylistData['stylistCategory'],
                          ),
                          const SizedBox(height: 8),
                          RatingBar.builder(
                            initialRating: currentRating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 24,
                            unratedColor: Colors.grey[400]!,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                currentRating = rating;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () async {
                              if (currentRating > 0) {
                                await submitRating();
                              }
                            },
                            child: Text('Submit Rating'),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(() => ReviewsScreen(docId: widget.doc.id));
                      },
                      icon: Icon(Icons.rate_review),
                      color: AppColors.primeryColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.bgDarkColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Average Rating: $averageRating ($ratingCount ratings)',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Base Price',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      stylistData['stylistAbout'],
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Address',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      stylistData['stylistAddress'],
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Working Time',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      stylistData['stylistTiming'],
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Is available For Home Services:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      stylistData['stylistService'] == 'Yes' ? 'Yes' : 'No',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: reviewController,
                decoration: InputDecoration(
                  labelText: 'Write a review',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (reviewController.text.isNotEmpty) {
                    await submitReview();
                  }
                },
                child: Text('Submit Review'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitRating() async {
    var stylistRef =
        FirebaseFirestore.instance.collection('stylists').doc(widget.doc.id);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      var stylistDoc = await transaction.get(stylistRef);
      if (!stylistDoc.exists) {
        throw Exception("Stylist does not exist!");
      }

      double currentStylistRating =
          stylistDoc['stylistRating']?.toDouble() ?? 0.0;
      int currentRatingCount = stylistDoc['ratingCount']?.toInt() ?? 0;

      double newRating =
          (currentStylistRating * currentRatingCount + currentRating) /
              (currentRatingCount + 1);
      int newRatingCount = currentRatingCount + 1;

      transaction.update(stylistRef, {
        'stylistRating': newRating,
        'ratingCount': newRatingCount,
      });
    });

    await sendNotification("You have received a new rating!");
  }

  Future<void> submitReview() async {
    var reviewData = {
      'reviewText': reviewController.text,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('stylists')
        .doc(widget.doc.id)
        .collection('reviews')
        .add(reviewData);

    reviewController.clear();

    await sendNotification("You have received a new review!");
  }

  Future<void> sendNotification(String message) async {
    // Get the stylist's FCM token (assuming 'token' field exists in Firestore document)
    var stylistData = await FirebaseFirestore.instance
        .collection('stylists')
        .doc(widget.doc.id)
        .get();
    var stylistToken = stylistData['token'];

    // if (stylistToken != null) {
    //   await FirebaseMessaging.instance.send(
    //     Message(
    //       token: stylistToken,
    //       notification: Notification(
    //         title: 'New Review or Rating',
    //         body: message,
    //       ),
    //     ),
    //   );
    // }
  }
}
