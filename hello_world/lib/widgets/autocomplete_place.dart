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
    });
  }

  void onSearch(String input) {
    setState(() {
      _filteredPlaces = _allPlaces
          .where((place) => place.name.toLowerCase().contains(input.toLowerCase()))
          .toList();
      _selectedPlace = null; // reset selection on each new input
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
              decoration: InputDecoration(hintText: 'Commence à taper une ville…'),
              onChanged: onSearch
          ),
          SizedBox(height: 8),
          if (_filteredPlaces.isNotEmpty)
            SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: _filteredPlaces.length,
                itemBuilder: (context, index) {
                  final place = _filteredPlaces[index];
                  return ListTile(
                    title: Text(place.name),
                    onTap: () {
                      setState(() {
                        _controller.text = place.name;
                        _selectedPlace = place;
                        _filteredPlaces = [];
                      });
                    },
                  );
                },
              ),
            ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // Si une ville a été sélectionnée dans la liste, prends son lat/lng
              // Sinon, essaie de matcher le nom saisi manuellement
              Place? selected = _selectedPlace;
              if (selected == null) {
                // Recherche par nom exact
                final matches = _allPlaces
                  .where((place) => place.name.toLowerCase() == _controller.text.toLowerCase())
                  .toList();
                if (matches.isNotEmpty) selected = matches.first;
              }
              if (selected != null) {
                widget.onPlaceSelected(selected);
                Navigator.pop(context);
              } else {
                // Optionnel : afficher une alerte ou un message d’erreur
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Ville non reconnue – sélectionnez dans la liste"))
                );
              }
            },
            child: Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
