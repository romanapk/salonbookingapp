import '../../../Utils/app_style.dart';
import '../../../general/consts/consts.dart';
import '../../../stylist_dashboard/widgets/coustom_button.dart';
import '../../book_appointment/view/appointment_view.dart';

class DoctorProfile extends StatelessWidget {
  final DocumentSnapshot doc;
  const DoctorProfile({Key? key, required this.doc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                          onRatingUpdate: (value) {},
                          maxRating: 5,
                          count: 5,
                          value: double.parse(doc['stylistRating'].toString()),
                          stepInt: true,
                        ),
                      ],
                    ),
                    const Spacer(),
                    "See All reviews".text.color(AppColors.primeryColor).make()
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
                docId: doc['stylistId'],
                docName: doc['stylistName'],
                docNum: doc['stylistPhone'],
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
