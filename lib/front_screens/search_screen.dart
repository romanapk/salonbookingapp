import '../../../general/list/home_icon_list.dart';
import '../Utils/app_style.dart';
import '../customer_dashboard/category_details/view/category_details.dart';
import '../customer_dashboard/home/controller/home_controller.dart';
import '../customer_dashboard/search/controller/search_controller.dart';
import '../customer_dashboard/search/view/search_view.dart';
import '../customer_dashboard/widgets/coustom_textfield.dart';
import '../general/consts/consts.dart';
import '../stylist_dashboard/stylist_profile/stylist_profile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    var searchController = Get.put(DocSearchController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.bgColor,
        title: Row(
          children: [
            Text("Welcome"),
            SizedBox(width: 5),
            Text("User"),
          ],
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search section
            Container(
              padding: const EdgeInsets.all(8),
              height: 70,
              color: AppColors.whiteColor,
              child: Row(
                children: [
                  Expanded(
                    child: CoustomTextField(
                      textcontroller: searchController.searchQueryController,
                      hint: AppString.search,
                      icon: const Icon(Icons.person_search_sharp),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      Get.to(() => SearchView(
                            searchQuery:
                                searchController.searchQueryController.text,
                          ));
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: iconList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => CategoryDetailsView(
                                  catName: iconListTitle[index],
                                ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              children: [
                                Image.asset(
                                  iconList[index],
                                  width: 50,
                                ),
                                SizedBox(height: 5),
                                Text(iconListTitle[index]),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  // Popular stylists
                  Text(
                    "Popular Stylists",
                    style: TextStyle(
                      color: Styles.orangeColor,
                      fontSize: AppFontSize.size16,
                    ),
                  ),
                  SizedBox(height: 10),
                  FutureBuilder<QuerySnapshot>(
                    future: controller.getDoctorList(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No data available'));
                      }
                      var data = snapshot.data!.docs;

                      // Sort data by average rating
                      data.sort((a, b) {
                        var aRating = (a.data()
                                as Map<String, dynamic>)['stylistRating'] ??
                            0.0;
                        var bRating = (b.data()
                                as Map<String, dynamic>)['stylistRating'] ??
                            0.0;
                        return bRating.compareTo(aRating);
                      });

                      return SizedBox(
                        height: 195,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            var docData =
                                data[index].data() as Map<String, dynamic>;
                            var stylistName =
                                docData['stylistName'] ?? 'Unknown';
                            var stylistCategory =
                                docData['stylistCategory'] ?? 'Unknown';

                            return GestureDetector(
                              onTap: () {
                                Get.to(() => StylistProfile(doc: data[index]));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.bgDarkColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.only(bottom: 5),
                                margin: const EdgeInsets.only(right: 8),
                                height: 120,
                                width: 130,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Container(
                                        color: AppColors.whiteColor,
                                        height: 130,
                                        width: double.infinity,
                                        child: Image.asset(
                                          AppAssets.imgDoctor,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    Text(
                                      stylistName.toString(),
                                      style: TextStyle(
                                          fontSize: AppFontSize.size16),
                                    ),
                                    Text(
                                      stylistCategory.toString(),
                                      style: TextStyle(
                                          fontSize: AppFontSize.size12),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => SearchView(searchQuery: ''));
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(
                          color: AppColors.primeryColor,
                          fontSize: AppFontSize.size16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
