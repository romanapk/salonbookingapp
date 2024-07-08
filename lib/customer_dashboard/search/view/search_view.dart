import 'package:salonbookingapp/general/consts/consts.dart';

import '../../../Utils/app_style.dart';
import '../../doctor_profile/view/doctor_view.dart';

class SearchView extends StatelessWidget {
  final String searchQuery;
  const SearchView({Key? key, required this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.textColor,
        title: Text("Search results"),
        elevation: 0,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('acceptedStylists').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No Stylist found, try another name"),
            );
          } else {
            var filteredStylists = snapshot.data!.docs.where((doc) {
              return doc['stylistName']
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
            }).toList();

            if (filteredStylists.isEmpty) {
              return Center(
                child: Text("No Stylist found, try another name"),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 250,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: filteredStylists.length,
                itemBuilder: (BuildContext context, index) {
                  var doc = filteredStylists[index];
                  String profilePictureUrl = doc['profilePicture'] ?? '';

                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        () => DoctorProfile(
                          doc: doc,
                        ),
                      );
                    },
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: AppColors.bgDarkColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.only(bottom: 5),
                      margin: const EdgeInsets.only(right: 8),
                      height: 250,
                      width: 180,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              profilePictureUrl,
                              width: double.infinity,
                              height: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  AppAssets.imgLogin,
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          const Divider(),
                          Text(
                            doc['stylistName'].toString(),
                            style: TextStyle(fontSize: AppFontSize.size16),
                          ),
                          VxRating(
                            onRatingUpdate: (value) {},
                            maxRating: 5,
                            count: 5,
                            value:
                                double.parse(doc['stylistRating'].toString()),
                            stepInt: true,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
