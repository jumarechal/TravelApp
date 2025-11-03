import 'package:flutter/material.dart';
import '../models/place.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AutocompletePlace extends StatefulWidget {
  final Function(Place) onPlaceSelected;
  AutocompletePlace({required this.onPlaceSelected});

  @override
  _AutocompletePlaceState createState() => _AutocompletePlaceState();
}

class _AutocompletePlaceState extends State<AutocompletePlace> {
  final TextEditingController _controller = TextEditingController();
  List<Place> _allPlaces = [];
  List<Place> _filteredPlaces = [];

  @override
  void initState() {
    super.initState();
    loadCities();
  }

  Future<void> loadCities() async {
    final data = await rootBundle.loadString('data/cities_france.json');
    final List<dynamic> jsonResult = json.decode(data);
    setState(() {
      _allPlaces = jsonResult.map((e) => Place.fromJson(e)).toList();
    });
  }

  void onSearch(String input) {
    setState(() {
      _filteredPlaces = _allPlaces
          .where((place) => place.name.toLowerCase().contains(input.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ajouter un lieu de couchage'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Ville en France'),
              onChanged: onSearch
          ),
          SizedBox(height: 8),
          if (_filteredPlaces.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: _filteredPlaces.length,
                itemBuilder: (context, index) {
                  final place = _filteredPlaces[index];
                  return ListTile(
                    title: Text(place.name),
                    onTap: () {
                      widget.onPlaceSelected(place);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
