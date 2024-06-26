import 'package:salonbookingapp/general/consts/consts.dart';

import '../../../Utils/app_style.dart';
import '../../doctor_profile/view/doctor_view.dart';

class SearchView extends StatelessWidget {
  final String searchQuery;
  const SearchView({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.textColor,
        title: "Search results".text.make(),
        elevation: 0,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('stylists').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
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
                child: "No Stylist found, try another name".text.makeCentered(),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 200,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: filteredStylists.length,
                itemBuilder: (BuildContext context, index) {
                  var doc = filteredStylists[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        () => StylistProfileScreen(
                          stylistId: '',
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
                      height: 120,
                      width: 130,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              width: 130,
                              color: Styles.textColor,
                              child: Image.asset(
                                AppAssets.imgLogin,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const Divider(),
                          doc['stylistName']
                              .toString()
                              .text
                              .size(AppFontSize.size16)
                              .make(),
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
