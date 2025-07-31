class ChaletBookingCompletedModel {
  final int chaletId;
  final String chaletName;
  final String city;
  final String checkinDate;
  final String checkoutDate;
  final int numberOfGuests;
  final int numberOfBookingRooms;
  final int numberOfMorning;
  final int numberOfNight;
  final String bookingId;
  final List<String> chaletImage;

  ChaletBookingCompletedModel({
    required this.bookingId,
    required this.chaletImage,
    required this.chaletId,
    required this.chaletName,
    required this.city,
    required this.checkinDate,
    required this.checkoutDate,
    required this.numberOfGuests,
    required this.numberOfBookingRooms,
    required this.numberOfMorning,
    required this.numberOfNight,
  });

  factory ChaletBookingCompletedModel.fromJson(Map<String, dynamic> json) {
    var imagesList = json['chalet_images'] as List;
    List<String> images = imagesList.map((i) => i as String).toList();
    return ChaletBookingCompletedModel(
      chaletImage: images,
      bookingId: json['booking_id'],
      chaletId: json['chalet_id'],
      chaletName: json['chalet_name'],
      city: json['city'],
      checkinDate: json['checkin_date'],
      checkoutDate: json['checkout_date'],
      numberOfGuests: json['number_of_guests'],
      numberOfBookingRooms: json['number_of_booking_rooms'],
      numberOfMorning: json['number_of_morning'],
      numberOfNight: json['number_of_night'],
    );
  }
}
