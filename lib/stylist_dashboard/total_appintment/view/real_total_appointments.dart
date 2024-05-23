// import 'package:salonbookingapp/stylist_dashboard/appointment_details/view/appointment_details.dart';
//
// import '../../../general/consts/consts.dart';
// import '../../auth/view/login_page.dart';
// import '../controller/accepted_appointment.dart';
//
// class TotalAppointment extends StatelessWidget {
//   const TotalAppointment({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.put(AcceptedAppointmentController());
//
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(onPressed: () async {
//         await FirebaseAuth.instance.signOut();
//         Get.offAll(() => const LoginVieww());
//       }),
//       appBar: AppBar(
//         backgroundColor: AppColors.primeryColor,
//         title: "Total Appointments".text.make(),
//       ),
//       body: FutureBuilder<QuerySnapshot>(
//         future: controller.getAcceptedAppointments(),
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
