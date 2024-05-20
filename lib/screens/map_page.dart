import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  LatLng latLng;
  MapPage(this.latLng, {super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlutterMap(
      options: MapOptions(
          initialCenter: widget.latLng,
          initialZoom: 11,
          interactionOptions:
              const InteractionOptions(flags: InteractiveFlag.doubleTapZoom)),
      children: [
        openStreetMapTileLayer,
        MarkerLayer(
          markers: [
            Marker(
                point: widget.latLng,
                width: 60,
                height: 60,
                alignment: Alignment.centerLeft,
                child: const Icon(
                  Icons.location_pin,
                  size: 60,
                  color: Colors.red,
                ))
          ],
        )
      ],
    ));
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );
