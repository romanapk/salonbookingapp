// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// import '../../../Utils/app_style.dart';
// import '../../../general/consts/colors.dart';
// import '../../../general/consts/fonts.dart';
// import '../../../general/consts/images.dart';
// import '../../../stylist_dashboard/stylist_controller.dart';
// import '../../reviews/allreviewspage.dart';
// import '../../reviews/give_reviews_page.dart';
//
// class StylistProfile extends StatelessWidget {
//   final DocumentSnapshot doc;
//   const StylistProfile({Key? key, required this.doc}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var user = FirebaseAuth.instance.currentUser;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Styles.bgColor,
//         title: "Stylist's details".text.make(),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: AppColors.bgDarkColor,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       clipBehavior: Clip.hardEdge,
//                       height: 75,
//                       width: 75,
//                       child: Image.asset(
//                         AppAssets.imgLogin,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     15.widthBox,
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         doc['stylistName']
//                             .toString()
//                             .text
//                             .size(AppFontSize.size18)
//                             .make(),
//                         doc['stylistCategory'].toString().text.make(),
//                         8.heightBox,
//                         VxRating(
//                           onRatingUpdate: (value) {
//                             // Update stylist's average rating
//                             Get.find<StylistController>()
//                                 .rateStylist(doc.id, value as double);
//                           },
//                           maxRating: 5,
//                           count: 5,
//                           value: double.parse(doc['stylistRating'].toString()),
//                           stepInt: true,
//                         ),
//                         8.heightBox,
//                         "Average Rating: ${doc['averageRating']}".text.make(),
//                       ],
//                     ),
//                     const Spacer(),
//                     GestureDetector(
//                       onTap: () {
//                         Get.to(() => AllReviewsPage(stylistId: doc.id));
//                       },
//                       child: "See All Reviews"
//                           .text
//                           .color(AppColors.primeryColor)
//                           .make(),
//                     ),
//                   ],
//                 ),
//               ),
//               10.heightBox,
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: AppColors.bgDarkColor,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     "Base Price".text.semiBold.size(AppFontSize.size18).make(),
//                     5.heightBox,
//                     doc['stylistAbout']
//                         .toString()
//                         .text
//                         .size(AppFontSize.size14)
//                         .make(),
//                     10.heightBox,
//                     "Address".text.semiBold.size(AppFontSize.size18).make(),
//                     5.heightBox,
//                     doc['stylistAddress']
//                         .toString()
//                         .text
//                         .size(AppFontSize.size14)
//                         .make(),
//                     10.heightBox,
//                     "Working Time"
//                         .text
//                         .semiBold
//                         .size(AppFontSize.size18)
//                         .make(),
//                     5.heightBox,
//                     doc['stylistTiming']
//                         .toString()
//                         .text
//                         .size(AppFontSize.size14)
//                         .make(),
//                     10.heightBox,
//                     Column(
//                       children: [
//                         "Is available For Home Services:"
//                             .text
//                             .semiBold
//                             .size(AppFontSize.size18)
//                             .make(),
//                         5.heightBox,
//                         if (doc['stylistService'] == 'Yes')
//                           "Yes".text.size(AppFontSize.size14).make()
//                         else if (doc['stylistService'] == 'No')
//                           "No".text.size(AppFontSize.size14).make(),
//                         15.heightBox,
//                       ],
//                     ),
//                     15.heightBox,
//                     ElevatedButton(
//                       onPressed: () {
//                         Get.to(() => GiveReviewPage(stylistId: doc.id));
//                       },
//                       child: "Give Feedback or Review".text.make(),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StylistProfileScreen extends StatelessWidget {
  final String stylistId;

  const StylistProfileScreen({Key? key, required this.stylistId})
      : super(key: key);

  // Function to submit rating to Firestore
  Future<void> submitRating(String stylistId, int rating) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Add rating to 'ratings' collection
      await firestore.collection('ratings').add({
        'stylistId': stylistId,
        'rating': rating,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Calculate average rating and update 'stylists' document
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

      print('Rating submitted successfully');
    } catch (e) {
      print('Error submitting rating: $e');
      throw e; // Throw the error to handle it in the UI if needed
    }
  }

  // Function to fetch reviews for a stylist
  Future<List<DocumentSnapshot>> getReviews(String stylistId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('reviews')
          .where('stylistId', isEqualTo: stylistId)
          .get();

      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching reviews: $e');
      return []; // Return an empty list or handle the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stylist Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display stylist details (name, category, etc.)
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('stylists')
                  .doc(stylistId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var stylistData = snapshot.data!.data() as Map<String, dynamic>;
                var stylistName = stylistData['stylistName'];
                var stylistCategory = stylistData['stylistCategory'];
                var averageRating = stylistData['averageRating'] ?? 0.0;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stylist: $stylistName',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Category: $stylistCategory',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Average Rating: ${averageRating.toStringAsFixed(1)}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 16.0),

                    // Option to rate the stylist
                    Text(
                      'Rate this stylist:',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 8.0),
                    RatingSlider(
                      initialRating: averageRating.toDouble(),
                      onRatingChanged: (newRating) {
                        submitRating(stylistId, newRating);
                      },
                    ),

                    SizedBox(height: 16.0),

                    // Option to leave a review
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ReviewScreen(stylistId: stylistId)),
                        );
                      },
                      child: Text('Give Feedback'),
                    ),

                    SizedBox(height: 16.0),

                    // Button to see all reviews
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AllReviewsScreen(stylistId: stylistId)),
                        );
                      },
                      child: Text('See All Reviews'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RatingSlider extends StatefulWidget {
  final double initialRating;
  final ValueChanged<int> onRatingChanged;

  const RatingSlider(
      {Key? key, required this.initialRating, required this.onRatingChanged})
      : super(key: key);

  @override
  _RatingSliderState createState() => _RatingSliderState();
}

class _RatingSliderState extends State<RatingSlider> {
  double _currentRating = 0.0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentRating,
      min: 0,
      max: 5,
      divisions: 5,
      label: _currentRating.toString(),
      onChanged: (newRating) {
        setState(() {
          _currentRating = newRating;
        });
        widget.onRatingChanged(newRating.toInt());
      },
    );
  }
}

class ReviewScreen extends StatelessWidget {
  final String stylistId;

  const ReviewScreen({Key? key, required this.stylistId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave a Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReviewForm(stylistId: stylistId),
      ),
    );
  }
}

class ReviewForm extends StatefulWidget {
  final String stylistId;

  const ReviewForm({Key? key, required this.stylistId}) : super(key: key);

  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  int _rating = 3;

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      try {
        await firestore.collection('reviews').add({
          'stylistId': widget.stylistId,
          'rating': _rating,
          'review': _reviewController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        Navigator.pop(context);
      } catch (e) {
        print('Error submitting review: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rating:', style: TextStyle(fontSize: 18)),
          RatingSlider(
            initialRating: _rating.toDouble(),
            onRatingChanged: (newRating) {
              setState(() {
                _rating = newRating;
              });
            },
          ),
          TextFormField(
            controller: _reviewController,
            decoration: InputDecoration(labelText: 'Review'),
            maxLines: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your review';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitReview,
            child: Text('Submit Review'),
          ),
        ],
      ),
    );
  }
}

class AllReviewsScreen extends StatelessWidget {
  final String stylistId;

  const AllReviewsScreen({Key? key, required this.stylistId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Reviews'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future:
            StylistProfileScreen(stylistId: stylistId).getReviews(stylistId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No reviews found'));
          }

          List<DocumentSnapshot> reviews = snapshot.data!;

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              var reviewData = reviews[index].data() as Map<String, dynamic>;
              var rating = reviewData['rating'];
              var reviewText = reviewData['review'];

              return ListTile(
                title: Text('Rating: $rating'),
                subtitle: Text('Review: $reviewText'),
              );
            },
          );
        },
      ),
    );
  }
}
