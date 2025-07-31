import 'dart:convert';

import 'package:e_concierge_tourism/controller/model/payment_methods_accepted/payment_method_accepted_model.dart';

BookingPriceResponse bookingPriceResponseFromJson(String str) =>
    BookingPriceResponse.fromJson(json.decode(str));

String bookingPriceResponseToJson(BookingPriceResponse data) =>
    json.encode(data.toJson());

class BookingPriceResponse {
  String? message;
  PriceData? data;

  BookingPriceResponse({
    this.message,
    this.data,
  });

  factory BookingPriceResponse.fromJson(Map<String, dynamic> json) =>
      BookingPriceResponse(
        message: json["message"],
        data: json["data"] == null ? null : PriceData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class PriceData {
  double? roomPriceWithMealAndNumberOfRoomsAndNumberOfDays;
  double? taxAndServices;
  double? totalRoomsPriceWithTax;
  double? discountPrice;
  double? totalAmountToBePaid;
  String? offerPercentage;
  List<AcceptedPayments>? acceptedPayments;
  bool isPromocodeApplied;
  String? promocode;
  double? mealPrice;
  double? mealTax;
  String? message;

  PriceData({
    this.roomPriceWithMealAndNumberOfRoomsAndNumberOfDays,
    this.taxAndServices,
    this.totalRoomsPriceWithTax,
    this.discountPrice,
    this.totalAmountToBePaid,
    this.offerPercentage,
    this.acceptedPayments,
    this.isPromocodeApplied = false,
    this.promocode,
    this.message,
    this.mealPrice,
    this.mealTax,
  });

  factory PriceData.fromJson(Map<String, dynamic> json) => PriceData(
        roomPriceWithMealAndNumberOfRoomsAndNumberOfDays:
            json["property_price_with_days"] ?? 0.0,
        taxAndServices: json["tax_and_services"] ?? 0.0,
        totalRoomsPriceWithTax: json["total_price_with_tax"] ?? 0.0,
        discountPrice: json["discount_price"] ?? 0.0,
        totalAmountToBePaid: json["total_amount_to_be_paid"] ?? 0.0,
        offerPercentage: json["offer_percentage"] != null
            ? json["offer_percentage"].toString()
            : '0',
        isPromocodeApplied: json['promo_code_applied'],
        promocode: json['promo_code'],
        mealPrice: json['meal_price'],
        mealTax: json['meal_tax'],
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {
        "room_price_with_meal_and_days":
            roomPriceWithMealAndNumberOfRoomsAndNumberOfDays,
        "tax_and_services": taxAndServices,
        "total_price_with_tax": totalRoomsPriceWithTax,
        "discount_price": discountPrice,
        "total_amount_to_be_paid": totalAmountToBePaid,
        "offer_percentage": offerPercentage,
        "meal_tax": mealTax,
        "meal_price": mealPrice,
      };
}
