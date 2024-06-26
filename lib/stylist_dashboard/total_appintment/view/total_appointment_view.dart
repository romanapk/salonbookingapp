// import 'package:salonbookingapp/stylist_dashboard/appointment_details/view/appointment_details.dart';
//
// import '../../../general/consts/consts.dart';
// import '../../auth/view/login_page.dart';
// import '../controller/total_appointment.dart';
//
// class TotalAppointment extends StatelessWidget {
//   const TotalAppointment({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.put(TotalAppointmentcontroller());
//
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(onPressed: () async {
//         await FirebaseAuth.instance.signOut();
//         Get.offAll(() => const LoginVieww());
//       }),
//       appBar: AppBar(
//         backgroundColor: AppColors.primeryColor,
//         title: "Pending Appointments".text.make(),
//       ),
//       body: FutureBuilder<QuerySnapshot>(
//         future: controller.getPendingAppointments(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             var data = snapshot.data?.docs;
//
//             return Padding(
//               padding: const EdgeInsets.all(10),
//               child: ListView.builder(
//                 itemCount: data?.length ?? 0,
//                 itemBuilder: (BuildContext context, index) {
//                   return ListTile(
//                     onTap: () {
//                       Get.to(() => Appointmentdetails(
//                             doc: data[index],
//                           ));
//                     },
//                     leading: CircleAvatar(
//                       child: ClipOval(
//                         child: Image.asset(
//                           AppAssets.imgDoctor,
//                           fit: BoxFit.cover,
//                           width: 50,
//                           height: 50,
//                         ),
//                       ),
//                     ),
//                     title:
//                         data![index]['appName'].toString().text.semiBold.make(),
//                     subtitle:
//                         "${data[index]['appDay']} - ${data[index]['appTime']}"
//                             .toString()
//                             .text
//                             .make(),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.check, color: Colors.green),
//                           onPressed: () {
//                             controller.updateAppointmentStatus(
//                                 data[index].id, 'accepted');
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.close, color: Colors.red),
//                           onPressed: () {
//                             controller.updateAppointmentStatus(
//                                 data[index].id, 'rejected');
//                           },
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
