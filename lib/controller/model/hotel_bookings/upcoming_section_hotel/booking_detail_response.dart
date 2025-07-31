import 'dart:convert';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/hotel_list_model.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/upcoming_section_hotel/completed.dart';
import 'package:intl/intl.dart';

BookingDetailResponse bookingDetailResponseFromJson(String str) =>
    BookingDetailResponse.fromJson(json.decode(str));

String bookingDetailResponseToJson(BookingDetailResponse data) =>
    json.encode(data.toJson());

class BookingDetailResponse {
  int? id;
  String? type;
  String? status;
  PropertyDetails? propertyDetails;
  DateTime? checkin;
  DateTime? checkout;
  int? guestCount;
  int? numberOfRooms;
  int? numberOfMorning;
  int? numberOfNight;
  String? bookingId;
  String? bookedPrice;
  String? serviceCharge;
  String? discountAmount;
  double? taxAmount;
  GuestDetails? guestDetails;
  UserRatingReview? userRatingReview;
  List<RoomType>? roomTypes;
  DateTime? paymentWaitingTime;
  DateTime? availabilityTime;
  DateTime? paymentExpiryTime;
  String? paymentCategory;
  String? paymentStatus;
  String? qrCode;
  double? mealPrice;
  double? mealTax;

  BookingDetailResponse({
    this.id,
    this.type,
    this.status,
    this.propertyDetails,
    this.checkin,
    this.checkout,
    this.guestCount,
    this.numberOfRooms,
    this.numberOfMorning,
    this.numberOfNight,
    this.bookingId,
    this.bookedPrice,
    this.serviceCharge,
    this.discountAmount,
    this.taxAmount,
    this.guestDetails,
    this.userRatingReview,
    this.roomTypes,
    this.availabilityTime,
    this.paymentExpiryTime,
    this.paymentWaitingTime,
    this.paymentCategory,
    this.paymentStatus,
    this.qrCode,
    this.mealPrice,
    this.mealTax,
  });

  factory BookingDetailResponse.fromJson(Map<String, dynamic> json) =>
      BookingDetailResponse(
        id: json["id"],
        type: json["type"],
        status: json["status"],
        propertyDetails: json["property_details"] == null
            ? null
            : PropertyDetails.fromJson(json["property_details"]),
        checkin: json["checkin_date"] == null
            ? DateTime.now()
            : DateTime.parse(json["checkin_date"]),
        checkout: json["checkout_date"] == null
            ? DateTime.now()
            : DateTime.parse(json["checkout_date"]),
        guestCount: json["number_of_guests"],
        numberOfRooms: json["number_of_booking_rooms"],
        numberOfMorning: json["number_of_morning"],
        numberOfNight: json["number_of_night"],
        bookingId: json["booking_id"],
        bookedPrice: json["booked_price"],
        serviceCharge: json["service_fee"],
        discountAmount: json["discount_price"],
        paymentCategory: json['payment_category'],
        paymentStatus: json['payment_status'],
        qrCode: json['qr_code_url'],
        taxAmount: json["tax_and_services"] ?? 0.0,
        mealPrice: json["meal_price"] ?? 0.0,
        mealTax: (json["meal_tax"] ?? 0.0),
        paymentExpiryTime: json["payment_expiry_time"] == null
            ? null
            : DateTime.parse(DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(json["payment_expiry_time"], true)
                .toLocal()
                .toIso8601String()),
        availabilityTime: json["availability_waiting_time"] == null
            ? null
            : DateTime.parse(DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(json["availability_waiting_time"], true)
                .toLocal()
                .toIso8601String()),
        guestDetails: json["guest_details"] == null
            ? null
            : GuestDetails.fromJson(json["guest_details"]),
        userRatingReview: json["user_rating_review"] == null
            ? null
            : UserRatingReview.fromJson(json["user_rating_review"]),
        roomTypes: json["room_type"] == null
            ? []
            : List<RoomType>.from(
                json["room_type"]!.map((x) => RoomType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "status": status,
        "property_details": propertyDetails?.toJson(),
        "checkin":
            "${checkin!.year.toString().padLeft(4, '0')}-${checkin!.month.toString().padLeft(2, '0')}-${checkin!.day.toString().padLeft(2, '0')}",
        "checkout":
            "${checkout!.year.toString().padLeft(4, '0')}-${checkout!.month.toString().padLeft(2, '0')}-${checkout!.day.toString().padLeft(2, '0')}",
        "guest_count": guestCount,
        "number_of_rooms": numberOfRooms,
        "number_of_morning": numberOfMorning,
        "number_of_night": numberOfNight,
        "booking_id": bookingId,
        "booked_price": bookedPrice,
        "service_charge": serviceCharge,
        "discount_amount": discountAmount,
        "tax_amount": taxAmount,
        "guest_details": guestDetails?.toJson(),
        // "user_rating_review": userRatingReview?.toJson(),
        "room_types": roomTypes == null
            ? []
            : List<dynamic>.from(roomTypes!.map((x) => x.toJson())),
      };
}

class GuestDetails {
  String? firstName;
  String? lastName;
  String? email;
  String? mobileNumber;

  GuestDetails({
    this.firstName,
    this.lastName,
    this.email,
    this.mobileNumber,
  });

  factory GuestDetails.fromJson(Map<String, dynamic> json) => GuestDetails(
        firstName: json["first_name"],
        lastName: json["booking_lname"],
        email: json["booking_email"],
        mobileNumber: json["booking_mobilenumber"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "mobile_number": mobileNumber,
      };
}

class PropertyDetails {
  int? id;
  String? name;
  String? image;
  String? city;
  String? hotelRating;
  num? price;
  Map<String, dynamic>? policies;
  Hoteltype? propertyType;

  PropertyDetails({
    this.id,
    this.name,
    this.image,
    this.city,
    this.hotelRating,
    this.policies,
    this.price,
    this.propertyType,
  });

  factory PropertyDetails.fromJson(Map<String, dynamic> json) =>
      PropertyDetails(
          id: json["id"],
          name: json["hotel_name"] ?? json['name'],
          image: json['hotel_image'] != null
              ? json["hotel_image"].isNotEmpty
                  ? json["hotel_image"].first
                  : null
              : json["chalet_images"].isNotEmpty
                  ? json["chalet_images"] != null
                      ? json['chalet_images'].first['image']
                      : null
                  : null,
          price: json['price'] ?? 0,
          city: json["city_name"],
          hotelRating: json["hotel_rating"],
          propertyType: json["property_type"] == null
              ? null
              : Hoteltype.fromJson(json["property_type"]),
          policies: json['policies'] != null
              ? json['policies'].isEmpty
                  ? null
                  : json['policies']
              : json['post_policies']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "city": city,
        "hotel_rating": hotelRating,
      };
}

class RoomType {
  String? roomType;
  int? id;
  List<String>? meals;
  double? price;
  String? status;
  String? image;

  RoomType({
    this.roomType,
    this.id,
    this.meals,
    this.price,
    this.status,
    this.image,
  });

  factory RoomType.fromJson(Map<String, dynamic> json) => RoomType(
        roomType: json["room_type"],
        id: json["id"],
        meals: json["meals"] == null ? [] : [json["meals"]],
        price: json["price_per_night"],
        status: json["status"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "room_type": roomType,
        "id": id,
        "meals": meals == null ? [] : List<dynamic>.from(meals!.map((x) => x)),
        "price": price,
        "status": status,
      };
}
