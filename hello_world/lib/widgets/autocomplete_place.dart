import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class TestAutocomplete extends StatefulWidget {
  @override
  _TestAutocompleteState createState() => _TestAutocompleteState();
}

class _TestAutocompleteState extends State<TestAutocomplete> {
  List<Map<String, dynamic>> _allCities = [];
  List<Map<String, dynamic>> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    loadCities();
  }

  Future<void> loadCities() async {
    final data = await rootBundle.loadString('data/cities_france.json');
    final List<dynamic> jsonResult = json.decode(data);
    setState(() {
      _allCities = jsonResult.cast<Map<String, dynamic>>();
    });
    print('Chargement des villes: ${_allCities.length}'); // DEBUG
  }

  void filterCities(String input) {
    final filtered = _allCities.where((city) {
      return city['name'].toString().toLowerCase().startsWith(input.toLowerCase());
    }).toList();

    setState(() {
      _filteredCities = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Autocomplete')),
      body: Column(
        children: [
          TextField(
            onChanged: filterCities,
            decoration: InputDecoration(hintText: 'Tapez une ville'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredCities[index]['name']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
