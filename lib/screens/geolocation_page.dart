import 'dart:async';

import 'package:application_2/screens/map_page.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'dart:developer';

class GeolocationPage extends StatefulWidget {
  const GeolocationPage({super.key});

  @override
  State<GeolocationPage> createState() => _GeolocationPageState();
}

class _GeolocationPageState extends State<GeolocationPage> {
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;
  late String lat;
  late String long;
  String locationMessage = "Location message";
  StreamSubscription? positionStream;

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  @override
  void initState() {
    super.initState();
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      setState(() {
        _currentLocation = position;
      });
    });
  }

  @override
  void dispose() {
    positionStream!.cancel();

    super.dispose();
  }

  String _currentAdress = "";
  Future<Position> _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      log("service disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition();
  }

  _getAddressFromCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentLocation!.latitude, _currentLocation!.longitude);
      Placemark place = placemarks[0];

      setState(() {
        _currentAdress = "${place.locality}, ${place.country}";
      });
    } catch (e) {
      log('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get User Location'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Location coordinates',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            Text(
                // locationMessage,
                'Latitude = ${_currentLocation?.latitude} ; \nLongitude = ${_currentLocation?.longitude}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Location',
            ),
            const SizedBox(height: 20),
            Text(_currentAdress),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  _currentLocation = await _getCurrentLocation();
                  await _getAddressFromCoordinates();
                  setState(() {
                    lat = _currentLocation!.latitude.toString();
                    long = _currentLocation!.longitude.toString();
                  });
                },
                child: const Text('Get location')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapPage(LatLng(
                              _currentLocation!.latitude,
                              _currentLocation!.longitude))));
                },
                child: const Text('Open Map')),
          ],
        ),
      ),
    );
  }
}
