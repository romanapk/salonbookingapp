import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../Utils/app_style.dart';
import '../../../general/consts/colors.dart';
import '../../../general/consts/fonts.dart';
import '../../../general/consts/images.dart';
import '../../../stylist_dashboard/stylist_controller.dart';
import '../../all_reviews/give_review.dart';
import '../../all_reviews/reviews.dart';

class StylistProfile extends StatelessWidget {
  final DocumentSnapshot doc;
  const StylistProfile({Key? key, required this.doc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.bgColor,
        title: "Stylist's details".text.make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                    15.widthBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        doc['stylistName']
                            .toString()
                            .text
                            .size(AppFontSize.size18)
                            .make(),
                        doc['stylistCategory'].toString().text.make(),
                        8.heightBox,
                        VxRating(
                          onRatingUpdate: (value) {
                            // Update stylist's average rating
                            Get.find<StylistController>()
                                .rateStylist(doc.id, value as double);
                          },
                          maxRating: 5,
                          count: 5,
                          value: double.parse(doc['stylistRating'].toString()),
                          stepInt: true,
                        ),
                        8.heightBox,
                        "Average Rating: ${doc['averageRating']}".text.make(),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => AllReviewsPage(stylistId: doc.id));
                      },
                      child: "See All Reviews"
                          .text
                          .color(AppColors.primeryColor)
                          .make(),
                    ),
                  ],
                ),
              ),
              10.heightBox,
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.bgDarkColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Base Price".text.semiBold.size(AppFontSize.size18).make(),
                    5.heightBox,
                    doc['stylistAbout']
                        .toString()
                        .text
                        .size(AppFontSize.size14)
                        .make(),
                    10.heightBox,
                    "Address".text.semiBold.size(AppFontSize.size18).make(),
                    5.heightBox,
                    doc['stylistAddress']
                        .toString()
                        .text
                        .size(AppFontSize.size14)
                        .make(),
                    10.heightBox,
                    "Working Time"
                        .text
                        .semiBold
                        .size(AppFontSize.size18)
                        .make(),
                    5.heightBox,
                    doc['stylistTiming']
                        .toString()
                        .text
                        .size(AppFontSize.size14)
                        .make(),
                    10.heightBox,
                    Column(
                      children: [
                        "Is available For Home Services:"
                            .text
                            .semiBold
                            .size(AppFontSize.size18)
                            .make(),
                        5.heightBox,
                        if (doc['stylistService'] == 'Yes')
                          "Yes".text.size(AppFontSize.size14).make()
                        else if (doc['stylistService'] == 'No')
                          "No".text.size(AppFontSize.size14).make(),
                        15.heightBox,
                      ],
                    ),
                    15.heightBox,
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => GiveReviewPage(stylistId: doc.id));
                      },
                      child: "Give Feedback or Review".text.make(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
