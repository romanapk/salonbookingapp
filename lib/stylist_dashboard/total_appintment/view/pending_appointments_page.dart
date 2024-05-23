import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/pending_appointment.dart';

class PendingAppointmentsPage extends StatelessWidget {
  final PendingAppointmentController controller =
      Get.put(PendingAppointmentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pending Appointments"),
      ),
      body: Obx(() {
        if (controller.pendingAppointments.isEmpty) {
          return Center(child: Text("No pending appointments"));
        }
        return ListView.builder(
          itemCount: controller.pendingAppointments.length,
          itemBuilder: (context, index) {
            var appointment = controller.pendingAppointments[index];
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text(appointment['appName']),
                subtitle: Text(
                    "${appointment['appDay']} at ${appointment['appTime']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () {
                        controller.acceptAppointment(appointment.id);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        controller.rejectAppointment(appointment.id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
