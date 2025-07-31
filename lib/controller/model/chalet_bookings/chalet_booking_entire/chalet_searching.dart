import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/hotel_list_model.dart';

class ChaletSearchRequestModel {
  final String cityName;
  final String? checkinDate;
  final String? checkoutDate;
  final int? adults;
  final int? children;
  final double? rating;
  final int? reviewCount;
  final List<String>? amenities;
  final String? sorted;
  final String? members;
  //final Map<String, dynamic>? filter;
  final String? name;
  final String? image;
  final int? chaletID;
  final double? price;
  final double? lat;
  final double? lng;
  bool isAdded;
  bool isFavorite;
  BestOffersCommon? bestOffersCommon;
  final Hoteltype? chaletType;

  ChaletSearchRequestModel(
      {required this.cityName,
      this.reviewCount,
      this.checkinDate,
      this.checkoutDate,
      this.adults,
      this.children,
      this.rating,
      this.amenities,
      this.sorted,
      this.members,
      // this.filter,
      this.name,
      this.image,
      this.price,
      this.bestOffersCommon,
      this.isAdded = false,
      this.isFavorite = false,
      this.chaletID,
      this.lat,
      this.lng,
      this.chaletType});

  Map<String, dynamic> toJson() {
    return {
      'city_name': cityName,
      'checkin_date': checkinDate,
      'checkout_date': checkoutDate,
      // 'adults': adults,
      // 'children': children,
      'members': members,
      'rating': rating,
      'amenities': amenities,
      'sorted': sorted,
      // 'filter': filter
      if (lat != null) "latitude": lat,
      if (lng != null) "longitude": lng,
    };
  }

  factory ChaletSearchRequestModel.fromJson(Map<String, dynamic> json) {
    return ChaletSearchRequestModel(
      chaletID: json['id'],
      cityName: json['city'],
      image: json['main_image'],
      rating: json['rating'] ?? 5,
      reviewCount: json['review_count'] ?? 0,
      name: json['name'],
      isAdded: json["comparison"] ?? false,
      isFavorite: json["is_favorite"] ?? false,
      bestOffersCommon: json['promotion'] != null
          ? BestOffersCommon.fromJson(json['promotion'])
          : null,
      amenities: List<String>.from(json['amenities'] ?? []),
      price: json['price'],
      chaletType: json["chalettype"] == null
          ? null
          : Hoteltype.fromJson(json["chalettype"]),
    );
  }
}

class BestOffersCommon {
  int? id;
  String? title;
  String? description;
  String? discountPercentage;
  DateTime? startDate;
  DateTime? endDate;
  int? minimumSpend;
  String? statue;
  String? source;
  double? discountedPrice;

  BestOffersCommon({
    this.id,
    this.title,
    this.description,
    this.discountPercentage,
    this.startDate,
    this.endDate,
    this.minimumSpend,
    this.statue,
    this.source,
    this.discountedPrice,
  });

  factory BestOffersCommon.fromJson(Map<String, dynamic> json) =>
      BestOffersCommon(
        id: json["promotion_id"],
        title: json["title"],
        description: json["description"],
        discountPercentage: json["discount_percentage"]?.toString(),
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        minimumSpend: json["minimum_spend"],
        statue: json["statue"],
        source: json["source"],
        discountedPrice: json["discounted_price"],
      );

  Map<String, dynamic> toJson() => {
        "promotion_id": id,
        "title": title,
        "description": description,
        "discount_percentage": discountPercentage,
        "start_date":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "minimum_spend": minimumSpend,
        "statue": statue,
        "source": source,
        "discounted_price": discountedPrice,
      };
}
