import '../../../general/consts/consts.dart';
import '../Utils/app_style.dart';
import '../customer_dashboard/appointment_details/view/appointment_details.dart';
import '../customer_dashboard/total_appintment/controller/total_appointment.dart';

class CustomerTotalAppointment extends StatelessWidget {
  const CustomerTotalAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CustomerTotalAppointmentController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.bgColor,
        title: "All Appointments".text.make(),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: controller.getConfirmedAppointments(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var data = snapshot.data?.docs;

            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: data?.length ?? 0,
                itemBuilder: (BuildContext context, index) {
                  return ListTile(
                    onTap: () {
                      Get.to(() => Appointmentdetails(
                            doc: data[index],
                          ));
                    },
                    leading: CircleAvatar(
                      child: ClipOval(
                        child: Image.asset(
                          AppAssets.imgDoctor,
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                    title: data![index]['appStylistName']
                        .toString()
                        .text
                        .semiBold
                        .make(),
                    subtitle:
                        "${data[index]['appDay']} - ${data[index]['appTime']}"
                            .toString()
                            .text
                            .make(),
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
