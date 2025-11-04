import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/place.dart';
import '../widgets/autocomplete_place.dart';
import '../widgets/france_map.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Place> _places = [];

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  void _addPlace(Place place) {
    setState(() {
      _places.add(place);
    });
    _savePlaces();
  }

  Future<void> _loadPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('places');
    if (data != null) {
      final decoded = json.decode(data) as List;
      setState(() {
        _places = decoded.map((e) => Place.fromJson(e)).toList();
      });
    }
  }

  Future<void> _savePlaces() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('places', json.encode(_places.map((e) => e.toJson()).toList()));
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    return Scaffold(
      appBar: AppBar(title: Text('Mes Voyages')),
      body: Column(
        children: [
          Expanded(child: FranceMap(markers: _places)),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Ajouter un lieu de couchage'),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => AutocompletePlace(
                    onPlaceSelected: _addPlace,),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.travel_explore), label: 'Mes Voyages'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configuration'),
        ],
        onTap: (index) {
          // À compléter pour la navigation
        },
      ),
    );
  }
}
