import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class NearbyStylistsView extends StatefulWidget {
  @override
  _NearbyStylistsViewState createState() => _NearbyStylistsViewState();
}

class _NearbyStylistsViewState extends State<NearbyStylistsView> {
  late MapController _mapController;
  LatLng? _currentLocation;
  List<Marker> _stylistMarkers = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
    _fetchNearbyStylists();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _mapController.move(_currentLocation!, 15.0);
    });
  }

  Future<void> _fetchNearbyStylists() async {
    // Simulate fetching stylists from a database
    List<Map<String, dynamic>> stylists = [
      {"name": "Stylist 1", "location": LatLng(37.7749, -122.4194)},
      {"name": "Stylist 2", "location": LatLng(37.7849, -122.4094)},
      {"name": "Stylist 3", "location": LatLng(37.7649, -122.4294)},
    ];

    setState(() {
      _stylistMarkers = stylists.map((stylist) {
        return Marker(
          width: 80.0,
          height: 80.0,
          point: stylist["location"],
          builder: (ctx) => Icon(
            Icons.person_pin_circle,
            color: Colors.blue,
            size: 40.0,
          ),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nearby Stylists"),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _currentLocation ?? LatLng(0, 0),
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          if (_currentLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: _currentLocation!,
                  builder: (ctx) => Icon(
                    Icons.my_location,
                    color: Colors.red,
                    size: 40.0,
                  ),
                ),
                ..._stylistMarkers,
              ],
            ),
        ],
      ),
    );
  }
}
