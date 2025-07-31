import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/hotel_details.dart';

class Room {
  final int? id;
  final int? roomNumber;
  final int? totalOccupency;
  final bool? availability;
  final int? hotelId;
  final String? roomTypeName;
  final List<String> roomImage;
  final List<Amenity> amenities;
  final List<Meal> meals;
  final RefundInfo? refundInfo;

  Room({
    this.id,
    required this.meals,
    required this.amenities,
    required this.roomImage,
    required this.roomNumber,
    required this.totalOccupency,
    required this.availability,
    required this.hotelId,
    this.roomTypeName,
    this.refundInfo,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      amenities: json['aminity_name'] != null
          ? (json['aminity_name'] as List<dynamic>)
              .map((item) => Amenity.fromJson(item))
              .toList()
          : [],
      meals: List<Meal>.from(json["meals"].map((x) => Meal.fromJson(x))),
      roomImage: List<String>.from(json['room_images']),
      id: json['id'],
      roomNumber: json['room_number'],
      totalOccupency: json['total_occupancy'],
      availability: json['availability'],
      hotelId: json['hotel'],
      roomTypeName: (json['roomtype_name'] as List).isNotEmpty
          ? json['roomtype_name'][0]['room_types']
          : null,
      refundInfo: json['refund_policy'] == null
          ? null
          : RefundInfo.fromJson(json['refund_policy']),
    );
  }
}

class RoomOptionName {
  final int? id;
  final String? roomOptions;

  RoomOptionName({
    this.id,
    required this.roomOptions,
  });

  factory RoomOptionName.fromJson(Map<String, dynamic> json) {
    return RoomOptionName(id: json['id'], roomOptions: json['room_options']);
  }
}

class RoomTypePrice {
  final String? priceperNight;
  final String? pricePerNightIncludebreakfast;
  final String? pricePerNightIncludebreakfastwithDinner;
  final String? lunch;

  RoomTypePrice(
      {required this.priceperNight,
      required this.pricePerNightIncludebreakfast,
      required this.pricePerNightIncludebreakfastwithDinner,
      required this.lunch});

  factory RoomTypePrice.fromJson(Map<String, dynamic> json) {
    return RoomTypePrice(
      priceperNight: json['room_price'].toString(),
      pricePerNightIncludebreakfast: json['breakfast_price'].toString(),
      pricePerNightIncludebreakfastwithDinner: json['dinner_price'].toString(),
      lunch: json['lunch_price'].toString(),
    );
  }
}

class RefundInfo {
  String? refundType;
  String? title;
  int? hours;

  RefundInfo({this.refundType, this.hours, this.title});

  factory RefundInfo.fromJson(json) {
    return RefundInfo(
        refundType: json['refund_type'],
        hours: json['hour'],
        title: json['title']);
  }
}

class MealsModel {
  final String mealtype;
  final String mealprice;

  MealsModel({
    required this.mealtype,
    required this.mealprice,
  });

  factory MealsModel.fromJson(List<dynamic> json) {
    return MealsModel(
      mealtype: json[0] ?? '',
      mealprice: json[1] ?? '',
    );
  }
}

class Meal {
  int mealId;
  String mealType;

  Meal({
    required this.mealId,
    required this.mealType,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        mealId: json["meal_id"],
        mealType: json["meal_type"],
      );

  Map<String, dynamic> toJson() => {
        "meal_id": mealId,
        "meal_type": mealType,
      };
}
