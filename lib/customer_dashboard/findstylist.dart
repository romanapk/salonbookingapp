import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class FindStylistsPage extends StatelessWidget {
  Future<List<Map<String, dynamic>>> _getNearbyStylists(
      LatLng userLocation) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs
        .map((doc) => {
              'fullname': doc['fullname'],
              'address': doc['address'],
              'distance': Geolocator.distanceBetween(
                userLocation.latitude,
                userLocation.longitude,
                double.parse(doc['address'].split(', ')[0]),
                double.parse(doc['address'].split(', ')[1]),
              ),
            })
        .where((stylist) => stylist['distance'] <= 10000) // 10 km radius
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Find Nearby Stylists")),
      body: FutureBuilder<Position>(
        future: Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("Location data not available"));
          } else {
            LatLng userLocation =
                LatLng(snapshot.data!.latitude, snapshot.data!.longitude);
            return FutureBuilder<List<Map<String, dynamic>>>(
              future: _getNearbyStylists(userLocation),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No nearby stylists found"));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var stylist = snapshot.data![index];
                      return ListTile(
                        title: Text(stylist['fullname']),
                        subtitle: Text(
                            "${stylist['distance'].toStringAsFixed(2)} meters away"),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
