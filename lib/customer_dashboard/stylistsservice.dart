// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:latlong2/latlong.dart';
//
// class StylistService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final Distance _distance = Distance();
//
//   Future<List<Stylist>> fetchNearbyStylists(
//       Position customerPosition, double maxDistance) async {
//     try {
//       QuerySnapshot snapshot =
//           await _firestore.collection('acceptedStylists').get();
//       List<Stylist> stylists = snapshot.docs
//           .map((doc) {
//             var data = doc.data() as Map<String, dynamic>;
//             double stylistLat = data['lat'];
//             double stylistLng = data['lng'];
//             double distance = _distance.as(
//               LengthUnit.Kilometer,
//               LatLng(customerPosition.latitude, customerPosition.longitude),
//               LatLng(stylistLat, stylistLng),
//             );
//             if (distance <= maxDistance) {
//               return Stylist.fromFirestore(data, doc.id);
//             } else {
//               return null;
//             }
//           })
//           .where((stylist) => stylist != null)
//           .cast<Stylist>()
//           .toList();
//       return stylists;
//     } catch (e) {
//       throw Exception('Failed to load stylists: $e');
//     }
//   }
// }
