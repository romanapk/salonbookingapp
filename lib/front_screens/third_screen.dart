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
      body: Obx(() {
        if (controller.confirmedAppointments.isEmpty) {
          return const Center(
            child: Text("No confirmed appointments"),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: controller.confirmedAppointments.length,
            itemBuilder: (BuildContext context, index) {
              var appointment = controller.confirmedAppointments[index];
              return ListTile(
                onTap: () {
                  Get.to(() => Appointmentdetails(doc: appointment));
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
                title: appointment['appStylistName']
                    .toString()
                    .text
                    .semiBold
                    .make(),
                subtitle: "${appointment['appDay']} - ${appointment['appTime']}"
                    .toString()
                    .text
                    .make(),
                trailing: IconButton(
                  icon: Icon(Icons.cancel, color: Colors.red),
                  onPressed: () {
                    _showCancelConfirmationDialog(context, appointment.id);
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _showCancelConfirmationDialog(
      BuildContext context, String appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Cancel Appointment"),
          content: Text("Are you sure you want to cancel the appointment?"),
          actions: [
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Get.find<CustomerTotalAppointmentController>()
                    .cancelAppointment(appointmentId, context);
              },
            ),
          ],
        );
      },
    );
  }
}
