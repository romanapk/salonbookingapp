import '../../../general/consts/consts.dart';
import '../Utils/app_style.dart';
import '../admin_dashboard/appointment_details/view/appointment_details.dart';
import '../admin_dashboard/total_appintment/controller/total_appointment.dart';

class TotalAppointment extends StatelessWidget {
  const TotalAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put((TotalAppointmentcontroller()));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.bgColor,
        title: "All Appointmnets".text.make(),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: controller.getAppointments(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            // While data is being fetched, display a CircularProgressIndicator.
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