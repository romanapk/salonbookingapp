import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class Stylist {
  final String id;
  final String name;
  final String category;
  final double latitude;
  final double longitude;
  final LatLng location; // Example of storing location as LatLng
  final double distance; // Distance in kilometers

  Stylist({
    required this.id,
    required this.name,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.distance,
  });

  factory Stylist.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Stylist(
      id: doc.id,
      name: data['stylistName'] ?? '',
      category: data['stylistCategory'] ?? '',
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
      location: data['location'] ?? 0.0,
      distance: data['distance'] ?? 0.0,
    );
  }
}
