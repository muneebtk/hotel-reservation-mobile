import 'dart:convert';

FeaturedHotel featuredHotelFromJson(String str) =>
    FeaturedHotel.fromJson(json.decode(str));

class FeaturedHotel {
  List<FeaturedData>? data;
  String? msg;

  FeaturedHotel({
    this.data,
    this.msg,
  });

  factory FeaturedHotel.fromJson(Map<String, dynamic> json) => FeaturedHotel(
        data: json["data"] == null
            ? []
            : List<FeaturedData>.from(
                json["data"]!.map((x) => FeaturedData.fromJson(x))),
        msg: json["msg"],
      );
}

class FeaturedData {
  String? type;
  int? id;
  String? location;
  String? locality;
  double? price;
  double? discounPercentage;
  double? discountedPrice;
  String? name;
  num? rating;
  String? mainImage;
  DateTime? featuredValidFrom;
  DateTime? featuredValidTo;
  String? status;

  FeaturedData({
    this.type,
    this.id,
    this.location,
    this.price,
    this.name,
    this.rating,
    this.discounPercentage,
    this.discountedPrice,
    this.mainImage,
    this.featuredValidFrom,
    this.featuredValidTo,
    this.status,
    this.locality,
  });

  factory FeaturedData.fromJson(Map<String, dynamic> json) => FeaturedData(
        type: json["type"],
        id: json["id"] ?? 0,
        location: json["location"],
        locality: json["locality"],
        price: json["price"] ?? 0,
        discounPercentage: json["discounPercentage"] ?? 0,
        discountedPrice: json["discountedPrice"] ?? 0,
        name: json["name"],
        rating: json["rating"] ?? 0,
        mainImage: json["main_image"] ?? "",
        featuredValidFrom: json["featured_valid_from"] == null
            ? null
            : DateTime.parse(json["featured_valid_from"]),
        featuredValidTo: json["featured_valid_to"] == null
            ? null
            : DateTime.parse(json["featured_valid_to"]),
        status: json["status"],
      );
}
