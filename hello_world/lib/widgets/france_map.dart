import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/place.dart';

class FranceMap extends StatelessWidget {
  final List<Place> markers;
  final Function(Place) onMarkerTap;

  FranceMap({required this.markers, required this.onMarkerTap});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(46.6, 2.3), // centre France
        zoom: 5.5,
        minZoom: 5,
        maxZoom: 10,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: markers.map((place) => Marker(
            width: 50,
            height: 50,
            point: LatLng(place.lat, place.lng),
            builder: (ctx) => GestureDetector(
              onTap: () => onMarkerTap(place),
              child: Icon(Icons.push_pin, color: Colors.red, size: 36),
            ),
          )).toList(),
        ),
      ],
    );
  }
}
