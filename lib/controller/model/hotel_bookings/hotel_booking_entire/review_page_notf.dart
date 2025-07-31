import 'dart:convert';

class BookingModelNotf {
  // List<int> roomOptionsId;
  bool isMySelf;
  String bookingFname;
  String bookingLname;
  String bookingEmail;
  String bookingMobileNumber;
  double totalAmount;
  final String checkingDate;
  final String checkoutDate;
  final int members;
  final int adults;
  final int children;
  final int rooms;
  List<RoomParticularPrice> room;
  final double discount;
  final double serviceFee;
  final String? promocodeApplied;
  String paymentType;
  String discountPercentage;
  double? mealPrice;
  double? mealTax;
  double? taxAndServices;
  int? count;

  BookingModelNotf({
    // required this.roomOptionsId,
    this.promocodeApplied,
    required this.isMySelf,
    required this.adults,
    required this.children,
    required this.bookingFname,
    required this.bookingLname,
    required this.bookingEmail,
    required this.bookingMobileNumber,
    required this.totalAmount,
    required this.checkingDate,
    required this.checkoutDate,
    required this.members,
    required this.rooms,
    required this.room,
    required this.discount,
    required this.serviceFee,
    required this.discountPercentage,
    required this.paymentType,
    this.mealPrice,
    this.mealTax,
    this.taxAndServices,
    this.count,
  });

  Map<String, dynamic> toJson() {
    return {
      // 'RoomOptions_id': roomOptionsId,
      'is_my_self': isMySelf,
      'adults': adults,
      'children': children,
      'booking_fname': bookingFname,
      'booking_lname': bookingLname,
      'booking_email': bookingEmail,
      'booking_mobilenumber': bookingMobileNumber,
      'total_amount': totalAmount.toStringAsFixed(3),
      "checkin_date": checkingDate,
      "checkout_date": checkoutDate,
      "number_of_guests": members,
      "number_of_booking_rooms": rooms,
      'room': room.map((e) => e.toJson()).toList(),
      'discount_price': double.parse(discount.toStringAsFixed(3)),
      'service_fee': serviceFee,
      'promocode_applied': promocodeApplied ?? '',
      'discount_percentage_applied': discountPercentage,
      'payment_type': paymentType,
      "meal_tax": mealTax,
      "meal_price": mealPrice,
      "tax_and_services": taxAndServices?.toStringAsFixed(3),
      "count": count,
    };
  }
}

class RoomParticularPrice {
  final String roomPriceParticular;
  final int roomIdList;
  final int mealId;

  RoomParticularPrice(
      {required this.roomPriceParticular,
      required this.roomIdList,
      required this.mealId});
  Map<String, dynamic> toJson() {
    return {
      'price': roomPriceParticular,
      'room_id': roomIdList,
      'meal_id': mealId,
    };
  }
}

String promoCodeCheckModelToJson(PromoCodeCheckModel data) =>
    json.encode(data.toJson());

class PromoCodeCheckModel {
  String? checkinDate;
  String? checkoutDate;
  List<RoomWithMeal>? rooms;
  String? promocode;
  int? chalet;

  PromoCodeCheckModel(
      {this.rooms,
      this.promocode,
      this.chalet,
      this.checkinDate,
      this.checkoutDate});

  Map<String, dynamic> toJson() => {
        "checkin_date": checkinDate,
        "checkout_date": checkoutDate,
        if (rooms != null && rooms!.isNotEmpty)
          "rooms": List<dynamic>.from(rooms!.map((x) => x.toJson())),
        "promocode": promocode,
        if (chalet != null) "chalet": chalet,
      };
}

class RoomWithMeal {
  int roomId;
  String meal;
  int mealTypeId;
  String roomName;
  String price;

  RoomWithMeal({
    required this.roomId,
    required this.meal,
    required this.mealTypeId,
    required this.roomName,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        "room_id": roomId,
        "meal": meal,
        "meal_type_id": mealTypeId,
      };
}

BookingModel bookingModelFromJson(String str) =>
    BookingModel.fromJson(json.decode(str));

class BookingModel {
  String? message;
  BookingData? data;

  BookingModel({
    this.message,
    this.data,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        message: json["message"] ?? 'success',
        data: json["data"] == null ? null : BookingData.fromJson(json["data"]),
      );
}

class BookingData {
  int id;
  String? hotelName;
  String? bookingNumber;
  String? recipientName;
  String? firstName;
  String? secondName;
  DateTime? checkinDate;
  DateTime? checkoutDate;
  String? email;
  int? guests;
  double? totalAmount;
  String? address;
  String? contactNumber;
  String? qrcode;
  int adults;
  int children;
  String? paymentUrl;

  BookingData({
    required this.id,
    this.hotelName,
    this.bookingNumber,
    this.recipientName,
    this.firstName,
    this.secondName,
    this.checkinDate,
    this.checkoutDate,
    this.email,
    this.guests,
    this.totalAmount,
    this.address,
    this.contactNumber,
    this.qrcode,
    required this.adults,
    required this.children,
    this.paymentUrl,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) => BookingData(
        hotelName: json["hotel_name"],
        id: json['id'],
        bookingNumber: json["Booking_Number"],
        recipientName: json["recipient_name"],
        firstName: json["first_name"],
        secondName: json["second_name"],
        checkinDate: json["checkin_date"] == null
            ? null
            : DateTime.parse(json["checkin_date"]),
        checkoutDate: json["checkout_date"] == null
            ? null
            : DateTime.parse(json["checkout_date"]),
        email: json["email"],
        guests: json["Guests"],
        totalAmount: json["total_amount"],
        address: json["address"],
        contactNumber: json["contact_number"],
        qrcode: json["qrcode"],
        adults: json["adults"] ?? 0,
        children: json["children"] ?? 0,
      );
}
