import 'package:e_concierge_tourism/controller/model/hotel_bookings/upcoming_section_hotel/completed.dart';

class ChaletBookingUpcoming {
  int chaletId;
  int id;
  String chaletName;
  List<String> chaletImages;
  String city;
  String checkinDate;
  String checkoutDate;
  int numberOfGuests;
  String bookingId;
  double bookedPrice;
  double serviceCharge;
  double discountAmount;
  double? taxAmount;
  UserRatingReview? userRating;
  final String status;

  ChaletBookingUpcoming({
    required this.chaletId,
    required this.id,
    required this.chaletName,
    required this.chaletImages,
    required this.city,
    required this.checkinDate,
    required this.checkoutDate,
    required this.numberOfGuests,
    required this.bookingId,
    required this.bookedPrice,
    required this.serviceCharge,
    required this.discountAmount,
    this.taxAmount,
    required this.userRating,
    required this.status,
  });

  factory ChaletBookingUpcoming.fromJson(Map<String, dynamic> json) {
    return ChaletBookingUpcoming(
      chaletId: json['chalet_id'],
      id: json['id'],
      chaletName: json['chalet_name'],
      chaletImages: List<String>.from(json['chalet_images']),
      city: json['city'],
      userRating: json['user_rating_review'] != null
          ? UserRatingReview.fromJson(json['user_rating_review'])
          : null,
      checkinDate: json['checkin_date'],
      checkoutDate: json['checkout_date'],
      numberOfGuests: json['number_of_guests'],
      bookingId: json['booking_id'],
      bookedPrice: json['booked_price'].toDouble(),
      serviceCharge: json['service_charge'].toDouble(),
      discountAmount: json['discount_amount'].toDouble(),
      taxAmount: json['tax_amount']?.toDouble(),
        status: json['status'],
    );
  }
}
