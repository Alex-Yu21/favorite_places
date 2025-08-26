import 'dart:convert';

import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:favorite_places/secret.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/google_maps.dart' hide Icon;
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectedLocation});

  final void Function(PlaceLocation location) onSelectedLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=16&size=600x300&maptype=roadmap&markers=color:blue%7C$lat,$lng&key=$api';
  }

void _savePlace(double latitude, double longitude) {
  final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$api',
    );

    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: lat,
        longitude: lng,
        address: address,
      );

      _isGettingLocation = false;
    });
    widget.onSelectedLocation(_pickedLocation!);
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
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    
  }

  void _selecteOnMap() async {
    final pickedLocation = await Navigator.of(
      context,
    ).push<LatLng>(MaterialPageRoute(builder: (ctx) => MapScreen()));

    if (pickedLocation == null) {
      return;
    }



  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isGettingLocation) {
      previewContent = CircularProgressIndicator();
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
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              label: const Text('Get Current Location'),
              icon: Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: _selecteOnMap,
              label: const Text('Selecte on map'),
              icon: Icon(Icons.map),
            ),
          ],
        ),
      ],
    );
  }
}
