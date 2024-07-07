// import 'package:salonbookingapp/general/consts/consts.dart';
//
// import '../../../Utils/app_style.dart';
// import '../../doctor_profile/view/doctor_view.dart';
// import '../../search/controller/search_controller.dart';
// import '../../search/view/search_view.dart';
// import '../../widgets/coustom_textfield.dart';
// import '../controller/home_controller.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.put(HomeController());
//     var searchcontroller = Get.put(DocSearchController());
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Styles.bgColor,
//         title: Row(
//           children: [
//             AppString.welcome.text.make(),
//             5.widthBox,
//             "User".text.make()
//           ],
//         ),
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           children: [
//             //search section
//             Container(
//               padding: const EdgeInsets.all(8),
//               height: 70,
//               color: Styles.bgColor,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: CoustomTextField(
//                       textcontroller: searchcontroller.searchQueryController,
//                       hint: AppString.search,
//                       icon: const Icon(Icons.person_search_sharp),
//                     ),
//                   ),
//                   10.widthBox,
//                   IconButton(
//                       onPressed: () {
//                         Get.to(() => SearchView(
//                               searchQuery:
//                                   searchcontroller.searchQueryController.text,
//                             ));
//                       },
//                       icon: const Icon(Icons.search))
//                 ],
//               ),
//             ),
//             4.heightBox,
//             Padding(
//               padding: const EdgeInsets.all(8),
//               child: Column(
//                 children: [
//                   15.heightBox,
//                   //popular stylists
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: "Popular Stylists"
//                         .text
//                         .color(
//                           Styles.bgColor,
//                         )
//                         .size(AppFontSize.size16)
//                         .make(),
//                   ),
//                   10.heightBox,
//                   FutureBuilder<QuerySnapshot>(
//                     future: controller.getDoctorList(),
//                     builder: (BuildContext context,
//                         AsyncSnapshot<QuerySnapshot> snapshot) {
//                       if (!snapshot.hasData) {
//                         return const Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       } else {
//                         var data = snapshot.data?.docs;
//                         return SizedBox(
//                           height: 195,
//                           child: ListView.builder(
//                             physics: const BouncingScrollPhysics(),
//                             scrollDirection: Axis.horizontal,
//                             itemCount: data?.length ?? 0,
//                             itemBuilder: (BuildContext context, int index) {
//                               var stylistData =
//                                   data![index].data() as Map<String, dynamic>;
//                               return GestureDetector(
//                                 onTap: () {
//                                   Get.to(() => DoctorProfile(
//                                         doc: data[index],
//                                       ));
//                                 },
//                                 child: Container(
//                                   clipBehavior: Clip.hardEdge,
//                                   decoration: BoxDecoration(
//                                     color: AppColors.bgDarkColor,
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   padding: const EdgeInsets.only(bottom: 5),
//                                   margin: const EdgeInsets.only(right: 8),
//                                   height: 120,
//                                   width: 130,
//                                   child: Column(
//                                     children: [
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(15),
//                                         child: Container(
//                                           color: Styles.bgColor,
//                                           child: stylistData[
//                                                       'profilePicture'] !=
//                                                   null
//                                               ? Image.network(
//                                                   stylistData['profilePicture'],
//                                                   height: 130,
//                                                   width: double.infinity,
//                                                   fit: BoxFit.cover,
//                                                 )
//                                               : Image.asset(
//                                                   AppAssets.imgDoctor,
//                                                   height: 130,
//                                                   width: double.infinity,
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                         ),
//                                       ),
//                                       const Divider(),
//                                       stylistData['docName']
//                                           .toString()
//                                           .text
//                                           .size(AppFontSize.size16)
//                                           .make(),
//                                       stylistData['docCategory']
//                                           .toString()
//                                           .text
//                                           .size(AppFontSize.size12)
//                                           .make(),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                   GestureDetector(
//                     onTap: () {},
//                     child: Align(
//                       alignment: Alignment.centerRight,
//                       child: "View All"
//                           .text
//                           .color(AppColors.primeryColor)
//                           .size(AppFontSize.size16)
//                           .make(),
//                     ),
//                   ),
//                   20.heightBox,
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
