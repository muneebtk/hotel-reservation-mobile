class RoomDetails {
  final int roomId;
  final String roomTypesName;
  final double roomPrice;
  final List<String> roomImages;

  RoomDetails({
    required this.roomId,
    required this.roomTypesName,
    required this.roomPrice,
    required this.roomImages,
  });

  factory RoomDetails.fromJson(Map<String, dynamic> json) {
    var imagesList = json['room_images'] as List;
    List<String> images = imagesList.map((i) => i as String).toList();
    return RoomDetails(
        roomPrice: json['room_types_name']['booked_room_price'],
        roomId: json['room_types_name']['roommanagement__id'],
        roomTypesName: json['room_types_name']['room_types'],
        roomImages: images);
  }
}
