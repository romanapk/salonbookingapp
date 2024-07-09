import '../../../Utils/app_style.dart';
import '../../../general/consts/consts.dart';
import '../../../stylist_dashboard/widgets/coustom_button.dart';
import '../../book_appointment/view/appointment_view.dart';

class DoctorProfile extends StatelessWidget {
  final DocumentSnapshot doc;
  const DoctorProfile({Key? key, required this.doc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var stylistData = doc.data() as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.bgColor,
        title: Text(
          "Stylist's details",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
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
                    15.widthBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        stylistData['stylistName']
                            .toString()
                            .text
                            .size(AppFontSize.size18)
                            .make(),
                        stylistData['stylistCategory'].toString().text.make(),
                        8.heightBox,
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
                    const Spacer(),
                    //     "See All reviews".text.color(AppColors.primeryColor).make()
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
                    stylistData['stylistAbout']
                        .toString()
                        .text
                        .size(AppFontSize.size14)
                        .make(),
                    10.heightBox,
                    "Address".text.semiBold.size(AppFontSize.size18).make(),
                    5.heightBox,
                    stylistData['stylistAddress']
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
                    stylistData['stylistTiming']
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
                        if (stylistData['stylistService'] == 'Yes')
                          "Yes".text.size(AppFontSize.size14).make()
                        else if (stylistData['stylistService'] == 'No')
                          "No".text.size(AppFontSize.size14).make(),
                        15.heightBox,
                      ],
                    ),
                    15.heightBox,
                    ListTile(
                      title: "Contact Details"
                          .text
                          .semiBold
                          .size(AppFontSize.size16)
                          .make(),
                      subtitle: "Book an Appointment for contact details"
                          .text
                          .size(AppFontSize.size12)
                          .make(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: CoustomButton(
          onTap: () {
            Get.to(
              () => BookAppointmentView(
                docId: stylistData['stylistId'],
                docName: stylistData['stylistName'],
                docNum: stylistData['stylistPhone'],
                doc: doc,
              ),
            );
          },
          title: "Book an Appointment",
        ),
      ),
    );
  }
}
