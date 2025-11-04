class Place {
  final String name;
  final double lat;
  final double lng;
  String description;
  String address;

  Place({
    required this.name,
    required this.lat,
    required this.lng,
    this.description = '',
    this.address = '',
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    name: json['name'],
    lat: json['lat'],
    lng: json['lng'],
    description: json['description'] ?? '',
    address: json['address'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'lat': lat,
    'lng': lng,
    'description': description,
    'address': address,
  };
}
