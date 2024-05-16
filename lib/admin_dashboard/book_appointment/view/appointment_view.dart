import '../../../Utils/app_style.dart';
import '../../../general/consts/consts.dart';
import '../../widgets/coustom_button.dart';
import '../../widgets/coustom_textfield.dart';
import '../controller/book_appointment_controller.dart';

class BookAppointmentView extends StatelessWidget {
  final String docId;
  final String docNum;
  final String docName;
  final DocumentSnapshot doc;
  const BookAppointmentView({
    super.key,
    required this.docId,
    required this.docName,
    required this.docNum,
    required this.doc,
  });

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AppointmentController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.bgColor,
        title: docName.text.make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: controller.formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "Select Appointment date"
                    .text
                    .size(AppFontSize.size16)
                    .semiBold
                    .make(),
                CoustomTextField(
                  validator: controller.validdata,
                  textcontroller: controller.appDayController,
                  hint: "Select date",
                  icon: const Icon(Icons.calendar_month_outlined),
                ),
                10.heightBox,
                "Select Appointment Time"
                    .text
                    .size(AppFontSize.size16)
                    .semiBold
                    .make(),
                CoustomTextField(
                  validator: controller.validdata,
                  textcontroller: controller.appTimeController,
                  hint: "Select time",
                  icon: const Icon(Icons.watch_later),
                ),
                10.heightBox,
                "Name".text.size(AppFontSize.size16).semiBold.make(),
                CoustomTextField(
                  validator: controller.validdata,
                  textcontroller: controller.appNameController,
                  hint: "Customer's full name",
                  icon: const Icon(Icons.person),
                ),
                10.heightBox,
                "Mobile Number".text.size(AppFontSize.size16).semiBold.make(),
                CoustomTextField(
                  validator: controller.validdata,
                  textcontroller: controller.appMobileController,
                  hint: "Enter mobile number",
                  icon: const Icon(Icons.call),
                ),
                10.heightBox,
                Column(
                  children: [
                    if (doc['stylistService'] == 'Yes')
                      "Your Address"
                          .text
                          .size(AppFontSize.size16)
                          .semiBold
                          .make(),
                    if (doc['stylistService'] == 'Yes')
                      TextFormField(
                        controller: controller.appMessageController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.note_add),
                          hintText: "write your address",
                          hintStyle: TextStyle(),
                          border: OutlineInputBorder(borderSide: BorderSide()),
                        ),
                        validator: controller.validdata,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => Padding(
          padding: const EdgeInsets.all(10),
          child: controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : CoustomButton(
                  onTap: () async {
                    await controller.bookAppointment(
                        docId, docName, docNum, context);
                  },
                  title: "Confirm Appointment",
                ),
        ),
      ),
    );
  }
}
