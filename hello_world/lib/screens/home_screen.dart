import 'package:flutter/material.dart';
import '../widgets/france_map.dart';
import '../widgets/autocomplete_place.dart';
import '../models/place.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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

  void _addPlace(Place place) {
    setState(() {
      _places = List.from(_places)..add(place);
    });
    _savePlaces();
  }

  void _editPlace(Place place, String description, String address) {
    setState(() {
      int index = _places.indexWhere((p) => p.name == place.name && p.lat == place.lat && p.lng == place.lng);
      if (index != -1) {
        _places[index].description = description;
        _places[index].address = address;
      }
    });
    _savePlaces();
  }

  void _deletePlace(Place place) {
    setState(() {
      _places.removeWhere((p) => p.name == place.name && p.lat == place.lat && p.lng == place.lng);
    });
    _savePlaces();
  }

  void _showEditSheet(BuildContext context, Place place) {
    final TextEditingController descController = TextEditingController(text: place.description);
    final TextEditingController addrController = TextEditingController(text: place.address);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16, right: 16, top: 16,
          ),
          child: StatefulBuilder(builder: (context, setModalState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Modifier le lieu: ${place.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  TextField(
                    maxLines: 2,
                    decoration: InputDecoration(labelText: 'Description'),
                    controller: descController,
                  ),
                  SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(labelText: 'Adresse'),
                    controller: addrController,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _editPlace(place, descController.text, addrController.text);
                          Navigator.pop(context);
                        },
                        child: Text('Enregistrer'),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        icon: Icon(Icons.delete),
                        label: Text('Supprimer un lieu de couchage'),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Confirmer la suppression'),
                              content: Text('Voulez-vous vraiment supprimer ce lieu ?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Annuler')),
                                TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Supprimer')),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            _deletePlace(place);
                            Navigator.pop(context); // ferme le bottom sheet
                          }
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    return Scaffold(
      appBar: AppBar(title: Text('Mes Voyages')),
      body: Column(
        children: [
          Expanded(
            child: FranceMap(
              markers: _places,
              onMarkerTap: (place) => _showEditSheet(context, place),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Ajouter un lieu de couchage'),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => AutocompletePlace(
                    onPlaceSelected: _addPlace,
                  ),
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
