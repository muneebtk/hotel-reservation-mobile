import 'package:e_concierge_tourism/controller/model/hotel_bookings/upcoming_section_hotel/rooms_details.dart';

class HotelBookingCancelled {
  final int hotelId;
  final int id;
  final String hotelName;
  final String city;
  final String checkinDate;
  final String checkoutDate;
  final int numberOfGuests;
  final int numberOfBookingRooms;
  final int numberOfMorning;
  final int numberOfNight;
  // final List<RoomDetails> roomDetails;
  final String bookingId;
  final double bookedPrice;
  final List<String> hotelImage;

  HotelBookingCancelled(
      {required this.bookingId,
      required this.id,
      required this.hotelImage,
      required this.hotelId,
      required this.hotelName,
      required this.city,
      required this.checkinDate,
      required this.checkoutDate,
      required this.numberOfGuests,
      required this.numberOfBookingRooms,
      required this.numberOfMorning,
      required this.numberOfNight,
      // required this.roomDetails,
      required this.bookedPrice});

  factory HotelBookingCancelled.fromJson(Map<String, dynamic> json) {
    var imagesList = json['hotel_images'] as List;
    List<String> images = imagesList.map((i) => i as String).toList();
    return HotelBookingCancelled(
      id: json['id'],
      hotelImage: images,
      bookedPrice: json['booked_price'],
      bookingId: json['booking_id'],
      hotelId: json['hotel_id'],
      hotelName: json['hotel_name'],
      city: json['city'],
      checkinDate: json['checkin_date'],
      checkoutDate: json['checkout_date'],
      numberOfGuests: json['number_of_guests'],
      numberOfBookingRooms: json['number_of_booking_rooms'],
      numberOfMorning: json['number_of_morning'],
      numberOfNight: json['number_of_night'],
      // roomDetails: (json['room_types_name'] as List<dynamic>)
      //     .map((item) => RoomDetails.fromJson(
      //         {'room_types_name': item, 'room_images': json['room_images']}))
      //     .toList(),
    );
  }
}
