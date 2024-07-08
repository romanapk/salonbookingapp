import '../../../Utils/app_style.dart';
import '../../../general/consts/consts.dart';
import '../../doctor_profile/view/doctor_view.dart';

class CategoryDetailsView extends StatelessWidget {
  final String catName;

  const CategoryDetailsView({Key? key, required this.catName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.bgColor,
        title: "$catName Artist ".text.make(),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('acceptedStylists')
            .where('stylistCategory', isEqualTo: catName)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No stylist found for $catName category.'),
            );
          }
          var data = snapshot.data!.docs;
          return Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 280, // Increased mainAxisExtent
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: data.length,
              itemBuilder: (BuildContext context, index) {
                var stylistData = data[index].data() as Map<String, dynamic>;
                return Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: AppColors.bgDarkColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          width: double.infinity,
                          height: 160,
                          color: Styles.bgColor,
                          child: stylistData['profilePicture'] != null
                              ? Image.network(
                                  stylistData['profilePicture'],
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  AppAssets.imgLogin,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            stylistData['stylistName']
                                .toString()
                                .text
                                .size(AppFontSize.size16)
                                .make(),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.attach_money, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  stylistData['stylistAbout'] ?? 'Price',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            VxRating(
                              onRatingUpdate: (value) {},
                              maxRating: 5,
                              count: 5,
                              value: double.parse(
                                  stylistData['stylistRating'].toString()),
                              stepInt: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).onTap(() {
                  Get.to(() => DoctorProfile(doc: data[index]));
                });
              },
            ),
          );
        },
      ),
    );
  }
}
