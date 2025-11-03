class Place {
  final String name;
  final double lat;
  final double lng;

  Place({required this.name, required this.lat, required this.lng});

  factory Place.fromJson(Map<String, dynamic> json) => Place(
      name: json['name'],
      lat: json['lat'],
      lng: json['lng']
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'lat': lat,
    'lng': lng,
  };
}
