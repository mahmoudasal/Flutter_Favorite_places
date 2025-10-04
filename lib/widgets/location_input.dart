import 'dart:convert';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  final void Function(PlaceLocation selectedLocation) onSelectLocation;
  const LocationInput({super.key, required this.onSelectLocation});

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  bool _isGettingLocation = false;

  Future<void> _savePlace(double? latitude, double? longtitude) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longtitude&key=AIzaSyBNFIewGVFrRzsozu7Xi9SN7JPZ6lUfX2M",
    );

    String address = '';
    try {
      final responce = await http.get(url);
      final resDate = json.decode(responce.body);
      address = resDate['results'][0]['formatted_address'];
      print(address);
    } catch (error) {
      print('Error getting address: $error');
      address = 'Unknown location';
      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get address. Using coordinates only.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: latitude!,
        longtitude: longtitude!,
        address: address,
      );
      _isGettingLocation = false;
    });

    widget.onSelectLocation(_pickedLocation!);
  }

  String get locatioImage {
    if (_pickedLocation == null) {
      return '';
    }

    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longtitude;
    return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyBNFIewGVFrRzsozu7Xi9SN7JPZ6lUfX2M";
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();

    setState(() {
      _isGettingLocation = false;
    });

    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    _savePlace(lat, lng);
  }

  void _selectOnMap() async {
    
    final pickedLocation = await Navigator.of(
      context,
    ).push<LatLng>(MaterialPageRoute(builder: (context) => MapScreen()));
    if (pickedLocation == null) {
      return;
    }
    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No Location chosen",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
    if (_pickedLocation != null) {
      previewContent = Image.network(
        locatioImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withAlpha(51),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: Icon(Icons.location_on),
              onPressed: _getCurrentLocation,
              label: const Text("Get Current Location"),
            ),
            TextButton.icon(
              icon: Icon(Icons.map),
              onPressed: _selectOnMap,
              label: const Text("Select on Map"),
            ),
          ],
        ),
      ],
    );
  }
}
