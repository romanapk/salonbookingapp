import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../Utils/app_style.dart';

class ReviewsScreen extends StatelessWidget {
  final String docId;
  const ReviewsScreen({Key? key, required this.docId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Reviews'),
        backgroundColor: Styles.bgColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('stylists')
            .doc(docId)
            .collection('reviews')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No reviews available'));
          }
          var reviews = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              var reviewData = reviews[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(reviewData['reviewText'] ?? 'No review text'),
                subtitle: Text(reviewData['timestamp']?.toDate().toString() ??
                    'No timestamp'),
              );
            },
          );
        },
      ),
    );
  }
}
