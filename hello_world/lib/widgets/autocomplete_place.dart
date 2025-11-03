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
  Place? _selectedPlace;

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
      _filteredPlaces = []; // pas de filtrage au départ
    });
  }

  void onSearch(String input) {
    if (input.isEmpty) {
      setState(() {
        _filteredPlaces = [];
        _selectedPlace = null;
      });
      return;
    }
    final filtered = _allPlaces
        .where((place) => place.name.toLowerCase().startsWith(input.toLowerCase()))
        .toList();

    setState(() {
      _filteredPlaces = filtered;
      _selectedPlace = null;
    });
  }

  void _selectPlace(Place place) {
    setState(() {
      _controller.text = place.name;
      _selectedPlace = place;
      _filteredPlaces = [];
    });
  }

  void _onAdd() {
    Place? selected = _selectedPlace;
    if (selected == null) {
      // Recherche correspondance exacte (case-insensitive)
      final exactMatches = _allPlaces.where(
          (place) => place.name.toLowerCase() == _controller.text.toLowerCase());
      if (exactMatches.isNotEmpty) selected = exactMatches.first;
    }

    if (selected != null) {
      widget.onPlaceSelected(selected);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ville non reconnue – veuillez sélectionner une ville dans la liste")),
      );
    }
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
            decoration: InputDecoration(hintText: 'Commencez à taper une ville…'),
            onChanged: onSearch,
          ),
          SizedBox(height: 8),
          if (_filteredPlaces.isNotEmpty)
            Container(
              height: 150,
              child: ListView.builder(
                itemCount: _filteredPlaces.length,
                itemBuilder: (context, index) {
                  final place = _filteredPlaces[index];
                  return ListTile(
                    title: Text(place.name),
                    onTap: () => _selectPlace(place),
                  );
                },
              ),
            ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: _onAdd,
            child: Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
