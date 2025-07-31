//? Hotel Model GET Method------------------------------------------------------
import 'dart:convert';

import 'package:e_concierge_tourism/controller/model/chalet_bookings/chalet_booking_entire/chalet_searching.dart';

List<HotelSearchList> hotelSearchListFromJson(String str) =>
    List<HotelSearchList>.from(
        json.decode(str).map((x) => HotelSearchList.fromJson(x)));

String hotelSearchListToJson(List<HotelSearchList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HotelSearchList {
  int? hotelId;
  String? hotelName;
  String? hotelAddress;
  String? city;
  double? pricePerNight;
  List<String>? hotelImage;
  double? avguserrating;
  String? hotelRating;
  bool isAdded;
  bool isFavorite;
  List<String>? avalibaleRoomTypes;
  BestOffersCommon? bestOffersCommon;
  Hoteltype? hoteltype;
  HotelRating? rating;

  HotelSearchList({
    this.hotelId,
    this.hotelName,
    this.hotelAddress,
    this.pricePerNight,
    this.hotelImage,
    this.avguserrating,
    this.hotelRating,
    this.avalibaleRoomTypes,
    this.bestOffersCommon,
    this.isAdded = false,
    this.isFavorite = false,
    this.hoteltype,
    this.rating,
    this.city
  });

  factory HotelSearchList.fromJson(Map<String, dynamic> json) =>
      HotelSearchList(
        hotelId: json["hotel_id"],
        hotelName: json["hotel_name"],
        hotelAddress: json["hotel_address"],
        city: json['city_name'],
        pricePerNight: json["price_per_night"],
        isAdded: json["compare"] ?? false,
        isFavorite: json["is_favorite"] ?? false,
        hotelImage: json["hotel_image"] == null
            ? []
            : List<String>.from(json["hotel_image"]!.map((x) => x)),
        avguserrating: json["avguserrating"] > 0 ? json["avguserrating"] : 5,
        hotelRating: json["hotel_rating"],
        avalibaleRoomTypes: json["avalibale_room_types"] == null
            ? []
            : List<String>.from(json["avalibale_room_types"]!.map((x) => x)),
        bestOffersCommon: json["best_offers_common"] != null
            ? BestOffersCommon.fromJson(json["best_offers_common"])
            : null,
        hoteltype: json["hoteltype"] == null
            ? null
            : Hoteltype.fromJson(json["hoteltype"]),
        rating: json["property_rating"] == null
            ? null
            : HotelRating.fromJson(json["property_rating"]),
      );

  Map<String, dynamic> toJson() => {
        "hotel_id": hotelId,
        "hotel_name": hotelName,
        "hotel_address": hotelAddress,
        "price_per_night": pricePerNight,
        "compare": isAdded,
        "hotel_image": hotelImage == null
            ? []
            : List<dynamic>.from(hotelImage!.map((x) => x)),
        "avguserrating": avguserrating,
        "hotel_rating": hotelRating,
        "avalibale_room_types": avalibaleRoomTypes == null
            ? []
            : List<dynamic>.from(avalibaleRoomTypes!.map((x) => x)),
        "best_offers_common": bestOffersCommon,
        "hoteltype": hoteltype?.toJson(),
      };
}

//? hotel model post method-------------------------------------------------------

class Hotel {
  final int? id;
  final String? officeNumber;
  final String? name;
  final String? address;
  final int numberOfRooms;
  final String hotelRating;
  final String crNumber;
  final String vatNumber;
  final String dateOfExpiry;
  final int vendor;
  final int country;
  final int city;
  final int state;
  final List<int> category;
  final List<int> roomTypes;

  Hotel({
    required this.id,
    required this.officeNumber,
    required this.name,
    required this.address,
    required this.numberOfRooms,
    required this.hotelRating,
    required this.crNumber,
    required this.vatNumber,
    required this.dateOfExpiry,
    required this.vendor,
    required this.country,
    required this.city,
    required this.state,
    required this.category,
    required this.roomTypes,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      officeNumber: json['office_number'],
      name: json['name'],
      address: json['address'],
      numberOfRooms: json['number_of_rooms'],
      hotelRating: json['hotel_rating'],
      crNumber: json['cr_number'],
      vatNumber: json['vat_number'],
      dateOfExpiry: json['date_of_expiry'],
      vendor: json['vendor'],
      country: json['country'],
      city: json['city'],
      state: json['state'],
      category: List<int>.from(json['category']),
      roomTypes: List<int>.from(json['room_types']),
    );
  }
}

class Hoteltype {
  String? type;
  String? icon;

  Hoteltype({
    this.type,
    this.icon,
  });

  factory Hoteltype.fromJson(Map<String, dynamic> json) => Hoteltype(
        type: json["type"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "icon": icon,
      };
}

class HotelRating {
  String? rating;
  String? icon;

  HotelRating({
    this.rating,
    this.icon,
  });

  factory HotelRating.fromJson(Map<String, dynamic> json) => HotelRating(
        rating: json["rating"],
        icon: json["icon"],
      );
}
