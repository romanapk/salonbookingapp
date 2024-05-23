import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Utils/app_style.dart'; // Import your app's style
import '../../../customer_dashboard/appointment_details/view/appointment_details.dart';
import '../controller/accepted_appointment.dart';

class AcceptedAppointmentsPage extends StatelessWidget {
  final AcceptedAppointmentController controller =
      Get.put(AcceptedAppointmentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accepted Appointments"),
        backgroundColor: Styles.bgColor, // Set app bar background color
      ),
      body: Obx(() {
        if (controller.acceptedAppointments.isEmpty) {
          return Center(
            child: Text(
              "No accepted appointments",
              style: TextStyle(color: Styles.textColor), // Set text color
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.acceptedAppointments.length,
          itemBuilder: (context, index) {
            var appointment = controller.acceptedAppointments[index];
            return GestureDetector(
              onTap: () {
                // Navigate to appointment details page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Appointmentdetails(doc: appointment),
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.all(10),
                color: Styles.darkColor, // Set card background color
                child: ListTile(
                  title: Text(
                    appointment['appName'],
                    style: TextStyle(color: Styles.textColor), // Set text color
                  ),
                  subtitle: Text(
                    "${appointment['appDay']} at ${appointment['appTime']}",
                    style: TextStyle(color: Styles.textColor), // Set text color
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.cancel, color: Colors.white),
                    onPressed: () {
                      _showCancelConfirmationDialog(context, appointment.id);
                    },
                  ),
                ),
              ),
            );
          },
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
                Get.find<AcceptedAppointmentController>()
                    .cancelAppointment(appointmentId, context);
              },
            ),
          ],
        );
      },
    );
  }
}
