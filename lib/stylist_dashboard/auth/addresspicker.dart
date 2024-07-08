import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class AddressPickerMap extends StatefulWidget {
  @override
  _AddressPickerMapState createState() => _AddressPickerMapState();
}

class _AddressPickerMapState extends State<AddressPickerMap> {
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Your Address'),
      ),
      body: Stack(
        children: [
          FlutterLocationPicker(
            initPosition: LatLong(33.6844, 73.0479), // Example initial location
            initZoom: 15,
            minZoomLevel: 5,
            maxZoomLevel: 20,
            trackMyPosition: true,
            searchBarBackgroundColor: Colors.white,
            onPicked: (pickedData) {
              setState(() {
                _selectedLocation = pickedData.latLong as LatLng?;
              });
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              child: const Icon(Icons.check),
              onPressed: () {
                if (_selectedLocation != null) {
                  Navigator.pop(context, _selectedLocation);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
