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

  @override
  void initState() {
    super.initState();
    loadCities();
  }

  Future<void> loadCities() async {
    final data = await rootBundle.loadString('lib/data/cities_france.json');
    final List<dynamic> jsonResult = json.decode(data);
    setState(() {
      _allPlaces = jsonResult.map((e) => Place.fromJson(e)).toList();
    });
  }

  void _onAdd() {
    String enteredCity = _controller.text.trim();
    if (enteredCity.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez saisir un nom de ville")),
      );
      return;
    }

    Place? selected;
    try {
      selected = _allPlaces.firstWhere(
          (place) => place.name.toLowerCase() == enteredCity.toLowerCase());
    } catch (e) {
      selected = null;
    }

    if (selected != null) {
      widget.onPlaceSelected(selected);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ville non reconnue. Veuillez vérifier l'orthographe.")),
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
            decoration: InputDecoration(hintText: 'Saisissez une ville en France'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _onAdd,
            child: Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
