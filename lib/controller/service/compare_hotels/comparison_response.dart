import 'dart:convert';

ComparisonModel comparisonModelFromJson(String str) =>
    ComparisonModel.fromJson(json.decode(str));

class ComparisonModel {
  String? msg;
  List<ComparisonData>? data;

  ComparisonModel({
    this.msg,
    this.data,
  });

  factory ComparisonModel.fromJson(Map<String, dynamic> json) =>
      ComparisonModel(
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<ComparisonData>.from(
                json["data"]!.map((x) => ComparisonData.fromJson(x))),
      );
}

class ComparisonData {
  int? id;
  String? location;
  double? price;
  String? name;
  num? rating;
  String? mainImage;
  List<String>? roomType;

  ComparisonData({
    this.location,
    this.price,
    this.name,
    this.rating,
    this.mainImage,
    this.id,
    this.roomType,
  });

  factory ComparisonData.fromJson(Map<String, dynamic> json) => ComparisonData(
        id: json['hotel_id'] ?? json["chalets_id"],
        location: json["location"],
        price: json["price"],
        name: json["name"],
        rating: json["rating"] ?? 0,
        mainImage: json["main_image"],
        roomType: json["room_type"] == null
            ? []
            : List<String>.from(json["room_type"]!.map((x) => x)),
      );
}
