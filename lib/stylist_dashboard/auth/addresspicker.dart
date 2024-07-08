import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class AddressPickerMap extends StatefulWidget {
  @override
  _AddressPickerMapState createState() => _AddressPickerMapState();
}

class _AddressPickerMapState extends State<AddressPickerMap> {
  LatLng? _selectedLocation;
  String _address = '';

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        setState(() {
          _address =
              '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
        });
      }
    } catch (e) {
      print('Error in converting latLng to address: $e');
    }
  }

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
              LatLng latLng = LatLng(
                  pickedData.latLong.latitude, pickedData.latLong.longitude);
              setState(() {
                _selectedLocation = latLng;
              });
              _getAddressFromLatLng(latLng).then((_) {
                if (_address.isNotEmpty) {
                  Navigator.pop(context,
                      {'location': _selectedLocation, 'address': _address});
                }
              });
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              child: const Icon(Icons.check),
              onPressed: () {
                if (_selectedLocation != null && _address.isNotEmpty) {
                  Navigator.pop(context,
                      {'location': _selectedLocation, 'address': _address});
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a location')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
