import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class AddressPickerMap extends StatefulWidget {
  final Function(LatLng) onLocationSelected;

  AddressPickerMap({required this.onLocationSelected});

  @override
  _AddressPickerMapState createState() => _AddressPickerMapState();
}

class _AddressPickerMapState extends State<AddressPickerMap> {
  late MapController _mapController;
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _mapController.move(_currentLocation!, 15.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Address")),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _currentLocation ?? LatLng(0, 0),
          zoom: 13.0,
          onTap: (tapPosition, point) {
            widget.onLocationSelected(point);
            Navigator.pop(context);
          },
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
                  point: _currentLocation!,
                  width: 80.0,
                  height: 80.0,
                  builder: (ctx) => Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40.0,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
