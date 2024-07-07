// import '../general/consts/consts.dart';
//
// class FeedbackForm extends StatefulWidget {
//   final String stylistDocId;
//   const FeedbackForm({Key? key, required this.stylistDocId}) : super(key: key);
//
//   @override
//   _FeedbackFormState createState() => _FeedbackFormState();
// }
//
// class _FeedbackFormState extends State<FeedbackForm> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _commentController = TextEditingController();
//   double _rating = 0.0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           VxRating(
//             onRatingUpdate: (value) {
//               setState(() {
//                 _rating = value as double;
//               });
//             },
//             maxRating: 5,
//             count: 5,
//             value: _rating,
//             stepInt: true,
//           ),
//           TextFormField(
//             controller: _commentController,
//             decoration: InputDecoration(
//               labelText: 'Leave a comment',
//             ),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter a comment';
//               }
//               return null;
//             },
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (_formKey.currentState?.validate() ?? false) {
//                 await FirebaseFirestore.instance
//                     .collection('acceptedStylists')
//                     .doc(widget.stylistDocId)
//                     .update({
//                   'feedbacks': FieldValue.arrayUnion([
//                     {
//                       'userId': FirebaseAuth.instance.currentUser!.uid,
//                       'rating': _rating,
//                       'comment': _commentController.text,
//                     }
//                   ]),
//                 });
//
//                 // Update the average rating
//                 await updateAverageRating(widget.stylistDocId);
//
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Feedback submitted')),
//                 );
//                 Navigator.of(context).pop();
//               }
//             },
//             child: Text('Submit'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// Future<void> updateAverageRating(String stylistDocId) async {
//   var stylistDoc = await FirebaseFirestore.instance
//       .collection('acceptedStylists')
//       .doc(stylistDocId)
//       .get();
//
//   if (!stylistDoc.exists ||
//       !stylistDoc.data()!.containsKey('feedbacks') ||
//       stylistDoc['feedbacks'] == null ||
//       (stylistDoc['feedbacks'] as List).isEmpty) {
//     await FirebaseFirestore.instance
//         .collection('acceptedStylists')
//         .doc(stylistDocId)
//         .update({'averageRating': 0});
//     return;
//   }
//
//   var feedbacks = stylistDoc['feedbacks'] as List<dynamic>;
//   var totalRating = 0.0;
//
//   for (var feedback in feedbacks) {
//     totalRating += feedback['rating'];
//   }
//
//   var averageRating = totalRating / feedbacks.length;
//
//   await FirebaseFirestore.instance
//       .collection('acceptedStylists')
//       .doc(stylistDoc.id)
//       .update({'averageRating': averageRating});
// }
