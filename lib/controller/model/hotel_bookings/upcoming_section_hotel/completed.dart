import 'package:e_concierge_tourism/controller/model/hotel_bookings/upcoming_section_hotel/rooms_details.dart';

class HotelBookingCompleted {
  final int id;
  final int hotelId;
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
  final double bookedprice;
  final List<String> hotelImage;
  final double tax;
  final double discountAmount;
  UserRatingReview? userRating;
  final String status;

  HotelBookingCompleted(
      {required this.tax,
      required this.id,
      this.status = '',
      required this.bookedprice,
      required this.bookingId,
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
      required this.userRating,
      required this.discountAmount});

  factory HotelBookingCompleted.fromJson(Map<String, dynamic> json) {
    var imagesList = json['hotel_images'] as List;
    List<String> images = imagesList.map((i) => i as String).toList();
    return HotelBookingCompleted(
      id: json['id'],
      tax: json['tax_amount'] ?? 0.0,
      bookedprice: json['booked_price'],
      hotelImage: images,
      bookingId: json['booking_id'],
      hotelId: json['hotel_id'],
      hotelName: json['hotel_name'],
      discountAmount: json['discount_amount'] ?? 0,
      city: json['city'],
      userRating: json['user_rating_review'] != null
          ? UserRatingReview.fromJson(json['user_rating_review'])
          : null,
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

class UserRatingReview {
  double rating;
  String review;

  UserRatingReview({
    required this.rating,
    required this.review,
  });

  factory UserRatingReview.fromJson(Map<String, dynamic> json) =>
      UserRatingReview(
        rating: json["rating"] ?? 1.0,
        review: json["review"] ?? '',
      );
}
