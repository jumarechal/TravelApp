import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/place.dart';

class FranceMap extends StatelessWidget {
  final List<Place> markers;
  FranceMap({required this.markers});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(46.603354, 1.888334),
        zoom: 5.5,
        minZoom: 5,
        maxZoom: 10,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a','b','c'],
        ),
        MarkerLayer(
          markers: markers.map((place) => Marker(
            width: 40,
            height: 40,
            point: LatLng(place.lat, place.lng),
            builder: (ctx) => Icon(Icons.push_pin, color: Colors.red, size: 36),
          )).toList(),
        ),
      ],
    );
  }
}
