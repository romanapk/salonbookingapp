import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class NearbyStylistsPage extends StatefulWidget {
  @override
  _NearbyStylistsPageState createState() => _NearbyStylistsPageState();
}

class _NearbyStylistsPageState extends State<NearbyStylistsPage> {
  Position? currentPosition;
  List<Stylist> nearbyStylists = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPosition = position;
    });
    _fetchNearbyStylists();
  }

  Future<void> _fetchNearbyStylists() async {
    if (currentPosition != null) {
      final double radius = 10.0; // Adjust the radius as needed (in kilometers)
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final QuerySnapshot querySnapshot = await firestore
          .collection('acceptedStylists')
          .where('latitude',
              isGreaterThanOrEqualTo:
                  currentPosition!.latitude - radius * 0.0089982311916)
          .where('latitude',
              isLessThanOrEqualTo:
                  currentPosition!.latitude + radius * 0.0089982311916)
          .where('longitude',
              isGreaterThanOrEqualTo: currentPosition!.longitude -
                  radius *
                      0.0089982311916 /
                      cos(currentPosition!.latitude * pi / 180))
          .where('longitude',
              isLessThanOrEqualTo: currentPosition!.longitude +
                  radius *
                      0.0089982311916 /
                      cos(currentPosition!.latitude * pi / 180))
          .get();

      List<Stylist> stylists = [];
      for (final doc in querySnapshot.docs) {
        final Stylist stylist = Stylist.fromFirestore(doc);
        final double distance = _calculateDistance(currentPosition!.latitude,
            currentPosition!.longitude, stylist.latitude, stylist.longitude);
        if (distance <= radius) {
          stylists.add(stylist);
        }
      }
      setState(() {
        nearbyStylists = stylists;
      });
    }
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Pi/180
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Stylists'),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.blueAccent,
            child: Center(
              child: Text(
                'Custom Map Placeholder',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          if (currentPosition != null)
            CustomPaint(
              painter: MapPainter(currentPosition!, nearbyStylists),
            ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                _fetchNearbyStylists();
              },
              child: Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }
}

class MapPainter extends CustomPainter {
  final Position currentPosition;
  final List<Stylist> nearbyStylists;

  MapPainter(this.currentPosition, this.nearbyStylists);

  @override
  void paint(Canvas canvas, Size size) {
    final double mapWidth = size.width;
    final double mapHeight = size.height;

    // Draw current location marker
    final Paint currentLocationPaint = Paint()..color = Colors.green;
    canvas.drawCircle(
        Offset(mapWidth / 2, mapHeight / 2), 10.0, currentLocationPaint);

    // Draw nearby stylists markers
    final Paint stylistMarkerPaint = Paint()..color = Colors.red;
    for (final stylist in nearbyStylists) {
      final double dx = _calculateXDistance(
          currentPosition.longitude, stylist.longitude, mapWidth);
      final double dy = _calculateYDistance(
          currentPosition.latitude, stylist.latitude, mapHeight);
      canvas.drawCircle(Offset(dx, dy), 10.0, stylistMarkerPaint);
    }
  }

  double _calculateXDistance(
      double longitude1, double longitude2, double mapWidth) {
    return mapWidth / 2 + (longitude2 - longitude1) * (mapWidth / 360);
  }

  double _calculateYDistance(
      double latitude1, double latitude2, double mapHeight) {
    return mapHeight / 2 - (latitude2 - latitude1) * (mapHeight / 180);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Stylist {
  final String name;
  final double latitude;
  final double longitude;

  Stylist({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Stylist.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Stylist(
      name: data['name'] ?? '',
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
    );
  }
}
