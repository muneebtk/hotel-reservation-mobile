class Place {
  final String name;
  final String vicinity;
  final String icon;
  final double latitude;
  final double longitude;
  String distance;
  final List<String> photos;

  Place({
    required this.name,
    required this.vicinity,
    required this.icon,
    required this.latitude,
    required this.longitude,
    required this.photos,
    required this.distance,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    var photosJson = json['photos'] as List<dynamic>?;
    List<String> photos = photosJson != null
        ? photosJson.map((photo) => photo['photo_reference'] as String).toList()
        : [];

    return Place(
        name: json['name'],
        vicinity: json['vicinity'],
        icon: json['icon'],
        latitude: json['geometry']['location']['lat'],
        longitude: json['geometry']['location']['lng'],
        photos: photos,
        distance: '');
  }
}
