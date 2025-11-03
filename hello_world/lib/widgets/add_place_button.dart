import 'package:flutter/material.dart';

class AddPlaceButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Ouvre le dialogue de recherche/autocomplétion
        // À compléter
      },
      icon: Icon(Icons.add),
      label: Text('Ajouter un lieu de couchage'),
    );
  }
}
