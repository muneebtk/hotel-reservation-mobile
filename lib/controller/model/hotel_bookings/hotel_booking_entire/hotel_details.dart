import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/hotel_list_model.dart';
import 'package:flutter/material.dart';

class HotelDetailsData {
  final int id;
  final String vendorFirstName;
  final String cityName;
  final String countryName;
  final String stateName;
  final List<String> hotelImage;
  final List<String> categoryName;
  final List<String> roomtypeName;
  final String officeNumber;
  final String name;
  num price;
  String address;
  final int numberOfRooms;
  final int roomsAvailable;
  final String hotelRating;
  final String crNumber;
  final String vatNumber;
  final String dateOfExpiry;
  final bool approved;
  final String logo;
  final String hotelId;
  final String aboutProperty;
  final Map<String, List<String>> policies;
  final List<String> cancellationPolicy;
  final String locality;
  final String hotelPolicies;
  final String buildingNumber;
  final bool postApproval;
  final List<String> propertyTypes;
  final List<Amenity> amenities;
  final int numberReview;
  final int numberRating;
  final double avgrating;
  final List<Review> reviews;
  final int total5star;
  final int total4star;
  final int total3star;
  final int total2star;
  final int total1star;
  final double countryTax;
  final double lat;
  final double lng;
  List<Offer> offers;
  TimeOfDay? checkin;
  TimeOfDay? checkout;
  List<PromoCode> promoCode;
  bool isFavorite;
  Hoteltype? propertyType;
  HotelRating? propertyRating;

  HotelDetailsData(
      {required this.id,
      required this.countryTax,
      required this.vendorFirstName,
      required this.cityName,
      required this.countryName,
      required this.stateName,
      required this.hotelImage,
      required this.categoryName,
      required this.roomtypeName,
      required this.officeNumber,
      required this.name,
      required this.address,
      required this.hotelPolicies,
      required this.numberOfRooms,
      required this.roomsAvailable,
      required this.hotelRating,
      required this.crNumber,
      required this.vatNumber,
      required this.dateOfExpiry,
      required this.approved,
      required this.logo,
      required this.hotelId,
      required this.aboutProperty,
      required this.policies,
      required this.cancellationPolicy,
      required this.locality,
      required this.buildingNumber,
      required this.postApproval,
      required this.propertyTypes,
      required this.amenities,
      required this.numberReview,
      required this.numberRating,
      required this.avgrating,
      required this.reviews,
      required this.total5star,
      required this.total4star,
      required this.total3star,
      required this.total2star,
      required this.total1star,
      required this.offers,
      required this.promoCode,
      required this.lat,
      required this.lng,
      required this.price,
      this.checkin,
      this.checkout,
      this.isFavorite = false,
      this.propertyType,
      this.propertyRating});

  factory HotelDetailsData.fromJson(Map<String, dynamic> json) {
    return HotelDetailsData(
        id: json['id'] ?? 0,
        price: json['price'] ?? 0,
        countryTax: json['country_tax'] ?? 0,
        vendorFirstName: json['vendor_first_name'] ?? '',
        cityName: json['city_name'] ?? '',
        countryName: json['country_name'] ?? '',
        hotelPolicies: json['hotel_policies'] ?? '',
        stateName: json['state_name'] ?? '',
        isFavorite: json['is_favorite'] ?? false,
        hotelImage: json['hotel_image'] != null
            ? List<String>.from(json['hotel_image'])
            : [],
        categoryName: json['category_name'] != null
            ? List<String>.from(
                json['category_name'].map((item) => item['category'] ?? ''))
            : [],
        roomtypeName: json['roomtype_name'] != null
            ? List<String>.from(json['roomtype_name'].map((item) => item))
            : [],
        offers: json["offers"] == null
            ? []
            : List<Offer>.from(json["offers"]!.map((x) => Offer.fromJson(x))),
        promoCode: json["promo_code"] == null
            ? []
            : List<PromoCode>.from(
                json["promo_code"]!.map((x) => PromoCode.fromJson(x))),
        checkin: json['checkin_time'] != null && json['checkin_time'].isNotEmpty
            ? TimeOfDay(
                hour: int.parse(json['checkin_time'].split(":")[0]),
                minute: int.parse(json['checkin_time'].split(":")[1]))
            : null,
        checkout:
            json['checkout_time'] != null && json['checkout_time'].isNotEmpty
                ? TimeOfDay(
                    hour: int.parse(json['checkout_time'].split(":")[0]),
                    minute: int.parse(json['checkout_time'].split(":")[1]))
                : null,
        officeNumber: json['office_number'] ?? '',
        name: json['hotel_name'] ?? '',
        address: json['address'] ?? '',
        numberOfRooms: json['number_of_rooms'] ?? 0,
        roomsAvailable: json['rooms_available'] ?? 0,
        hotelRating: json['hotel_rating'] ?? '',
        crNumber: json['cr_number'] ?? '',
        vatNumber: json['vat_number'] ?? '',
        dateOfExpiry: json['date_of_expiry'] ?? '',
        approved: json['approved'] ?? false,
        logo: json['logo'] ?? '',
        hotelId: json['hotel_id'] ?? '',
        aboutProperty: json['about_property'] ?? '',
        policies: json['policies'] != null
            ? Map<String, List<String>>.from(json['policies']
                .map((key, value) => MapEntry(key, List<String>.from(value))))
            : {},
        cancellationPolicy: json['cancellation_policy'] != null
            ? List<String>.from(json['cancellation_policy'])
            : [],
        locality: json['locality'] ?? '',
        buildingNumber: json['building_number'] ?? '',
        postApproval: json['post_approval'] ?? false,
        propertyTypes: json['property_types'] != null
            ? List<String>.from(json['property_types'])
            : [],
        amenities: json['aminity_name'] != null
            ? (json['aminity_name'] as List<dynamic>)
                .map((item) => Amenity.fromJson(item))
                .toList()
            : [],
        numberRating: json['number_of_ratings'] ?? 0,
        numberReview: json['number_of_reviews'] ?? 0,
        avgrating: json['avg_rating'] > 0 ? json['avg_rating'] : 5,
        reviews: json['reviews'] != null
            ? (json['reviews'] as List<dynamic>).map((item) => Review.fromJson(item)).toList()
            : [],
        total1star: json['numbers_of_total_1_star'] ?? 0,
        total2star: json['numbers_of_total_2_star'] ?? 0,
        total3star: json['numbers_of_total_3_star'] ?? 0,
        total4star: json['numbers_of_total_4_star'] ?? 0,
        total5star: json['numbers_of_total_5_star'] ?? 0,
        lat: json['lat'] ?? 0,
        lng: json['lng'] ?? 0,
        propertyType: json["property_type"] == null ? null : Hoteltype.fromJson(json["property_type"]),
        propertyRating: json["property_rating"] == null ? null : HotelRating.fromJson(json["property_rating"]));
  }
}

class Amenity {
  final String name;
  final String icon;

  Amenity({
    required this.name,
    required this.icon,
  });

  factory Amenity.fromJson(List<dynamic> json) {
    return Amenity(
      name: json[0] ?? '',
      icon: json[1] ?? '',
    );
  }
}

class Review {
  final String userName;
  final String reviewText;
  final String date;
  final num rating;

  Review({
    required this.rating,
    required this.userName,
    required this.reviewText,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userName: json['username'] ?? '',
      reviewText: json['review_text'] ?? '',
      date: json['date'] ?? '',
      rating: json['rating'] ?? 0,
    );
  }
}

class Offer {
  String? title;
  String? description;
  String? promotionType;
  double? discountPercentage;
  DateTime? startDate;
  DateTime? endDate;
  double? discountValue;
  String? code;

  Offer({
    this.title,
    this.description,
    this.promotionType,
    this.discountPercentage,
    this.startDate,
    this.code,
    this.discountValue,
    this.endDate,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        title: json["title"],
        description: json["description"],
        promotionType: json["promotion_type"],
        discountPercentage: json["discount_percentage"]?.toDouble(),
        discountValue: json["discount_value"],
        code: json["code"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
      );
}

class PromoCode {
  String? title;
  String? description;
  double? discountPercentage;
  dynamic discountValue;
  String? code;

  PromoCode({
    this.title,
    this.description,
    this.discountPercentage,
    this.discountValue,
    this.code,
  });

  factory PromoCode.fromJson(Map<String, dynamic> json) => PromoCode(
        title: json["title"],
        description: json["description"],
        discountPercentage: json["discount_percentage"] ?? 0,
        discountValue: json["discount_value"],
        code: json["code"],
      );
}
