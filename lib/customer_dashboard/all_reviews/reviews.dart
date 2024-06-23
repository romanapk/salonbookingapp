import 'package:salonbookingapp/general/consts/consts.dart';

import '../../../Utils/app_style.dart';

class AllReviewsPage extends StatelessWidget {
  final String stylistId;
  const AllReviewsPage({Key? key, required this.stylistId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.bgColor,
        title: "All Reviews".text.make(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reviews')
            .where('stylistId', isEqualTo: stylistId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error fetching reviews: ${snapshot.error}',
                style: TextStyle(color: Styles.textColor), // Set text color
              ),
            );
          }

          var reviews = snapshot.data!.docs;

          if (reviews.isEmpty) {
            return Center(
              child: Text(
                'No reviews yet',
                style: TextStyle(color: Styles.textColor), // Set text color
              ),
            );
          }

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              var review = reviews[index];
              var reviewData = review.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                color: AppColors.bgDarkColor, // Set card background color
                child: ListTile(
                  title: Text(
                    reviewData['message'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Styles.textColor, // Set text color
                    ),
                  ),
                  subtitle: Text(
                    'Rated: ${reviewData['rating']} stars',
                    style: TextStyle(
                      color: Styles.textColor
                          .withOpacity(0.7), // Set text color with opacity
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
