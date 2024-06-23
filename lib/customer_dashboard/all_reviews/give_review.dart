import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../Utils/app_style.dart';
import '../../general/consts/colors.dart';
import '../../general/consts/fonts.dart';

class GiveReviewPage extends StatelessWidget {
  final String stylistId;
  const GiveReviewPage({Key? key, required this.stylistId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController reviewController = TextEditingController();
    double rating = 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.bgColor,
        title: "Give Feedback or Review".text.make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "Rate the stylist:".text.size(AppFontSize.size18).make(),
            8.heightBox,
            VxRating(
              onRatingUpdate: (value) => rating = value as double,
              maxRating: 5,
              count: 5,
            ),
            16.heightBox,
            "Write your review:".text.size(AppFontSize.size18).make(),
            8.heightBox,
            TextField(
              controller: reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.bgDarkColor),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            16.heightBox,
            ElevatedButton(
              onPressed: () async {
                // Save review and rating
                await FirebaseFirestore.instance.collection('reviews').add({
                  'stylistId': stylistId,
                  'rating': rating,
                  'message': reviewController.text,
                  'timestamp': FieldValue.serverTimestamp(),
                });

                // Notify stylist about the new review
                await FirebaseFirestore.instance
                    .collection('notifications')
                    .add({
                  'userId': stylistId,
                  'message': 'You received a new review.',
                  'timestamp': FieldValue.serverTimestamp(),
                });

                Get.back(); // Navigate back after review submission
              },
              child: "Submit".text.make(),
            ),
          ],
        ),
      ),
    );
  }
}
