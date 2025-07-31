import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/hotel_details.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/hotel_list_model.dart';
import 'package:flutter/material.dart';

class ChaletModel {
  int? id;
  String? countryName;
  String? stateName;
  String? cityName;
  List<String>? categoryNames;
  List<Amenity>? amenities;
  final Map<String, List<String>>? chaletPolicies;
  List<ChaletImage>? chaletImages;
  num? pricePerNight;
  String? mainImage;
  String? officeNumber;
  String? name;
  String address;
  String? crNumber;
  String? vatNumber;
  String? dateOfExpiry;
  String? logo;
  String? chaletId;
  String? aboutProperty;
  //String? policies;
  String? locality;
  String? buildingNumber;
  bool? postApproval;
  TimeOfDay? checkinTime;
  TimeOfDay? checkoutTime;
  double? commissionPercentage;
  String? approvalStatus;
  String? nameArabic;
  String? ownerNameArabic;
  String? localityArabic;
  String? aboutPropertyArabic;
  String? policiesArabic;
  String? createdDate;
  bool? isBooked;
  String? status;
  int? vendor;
  int? country;
  int? city;
  double? lat;
  double? lng;
  ReviewData? reviewData;
  int? state;
  List<int>? category;
  List<String>? cancellationPolicy;
  List<Offer>? offers;
  bool isFavorite;
  Hoteltype? propertyType;
  String? about_policies;

  ChaletModel(
      {this.id,
      this.countryName,
      this.cancellationPolicy,
      this.stateName,
      this.cityName,
      this.categoryNames,
      this.amenities,
      this.chaletPolicies,
      this.chaletImages,
      this.pricePerNight,
      this.mainImage,
      this.officeNumber,
      this.name,
      required this.address,
      this.crNumber,
      this.vatNumber,
      this.dateOfExpiry,
      this.logo,
      this.chaletId,
      this.aboutProperty,
      //this.policies,
      this.locality,
      this.buildingNumber,
      this.postApproval,
      this.checkinTime,
      this.checkoutTime,
      this.commissionPercentage,
      this.approvalStatus,
      this.nameArabic,
      this.ownerNameArabic,
      this.localityArabic,
      this.aboutPropertyArabic,
      this.policiesArabic,
      this.createdDate,
      this.isBooked,
      this.status,
      this.vendor,
      this.country,
      this.city,
      this.state,
      this.lat,
      this.lng,
      this.category,
      this.offers,
      this.reviewData,
      this.isFavorite = false,
      this.propertyType,
      this.about_policies,
      });

  factory ChaletModel.fromJson(Map<String, dynamic> json) {
    return ChaletModel(
      // filter: Filter.fromJson(json['filter']),
      id: json['id'],
      countryName: json['country_name'],
      stateName: json['state_name'],
      about_policies: json['about_policies'],
      cityName: json['city_name'],
      cancellationPolicy: List<String>.from(json['cancellation_policy'] ?? []),
      categoryNames: List<String>.from(json['category_names'] ?? []),
      amenities: (json['amenities'] as List?)
          ?.map((e) => Amenity.fromJson(e))
          .toList(),
      chaletPolicies: json['post_policies'] != null
          ? Map<String, List<String>>.from(json['post_policies']
              .map((key, value) => MapEntry(key, List<String>.from(value))))
          : {},
      offers: json["offers"] == null
          ? []
          : List<Offer>.from(json["offers"]!.map((x) => Offer.fromJson(x))),
      chaletImages: (json['chalet_images'] as List?)
          ?.map((e) => ChaletImage.fromJson(e))
          .toList(),
      pricePerNight: json['price'],
      mainImage: json['main_image'],
      officeNumber: json['office_number'],
      name: json['name'],
      address: json['address'] ?? '',
      crNumber: json['cr_number'],
      vatNumber: json['vat_number'],
      dateOfExpiry: json['date_of_expiry'],
      logo: json['logo'],
      chaletId: json['chalet_id'],
      aboutProperty: json['about_property'],
      //policies: json['policies'],
      locality: json['locality'],
      buildingNumber: json['building_number'],
      postApproval: json['post_approval'],
      checkinTime:
          json['checkin_time'] != null && json['checkin_time'].isNotEmpty
              ? TimeOfDay(
                  hour: int.parse(json['checkin_time'].split(":")[0]),
                  minute: int.parse(json['checkin_time'].split(":")[1]))
              : null,
      checkoutTime:
          json['checkout_time'] != null && json['checkout_time'].isNotEmpty
              ? TimeOfDay(
                  hour: int.parse(json['checkout_time'].split(":")[0]),
                  minute: int.parse(json['checkout_time'].split(":")[1]))
              : null,
      commissionPercentage: json['commission_percentage']?.toDouble(),
      approvalStatus: json['approval_status'],
      nameArabic: json['name_arabic'],
      ownerNameArabic: json['owner_name_arabic'],
      localityArabic: json['locality_arabic'],
      aboutPropertyArabic: json['about_property_arabic'],
      policiesArabic: json['policies_arabic'],
      createdDate: json['created_date'],
      isBooked: json['is_booked'],
      status: json['status'],
      vendor: json['vendor'],
      country: json['country'],
      lat: json['latitude'] ?? 0.0,
      lng: json['longitude'] ?? 0.0,
      city: json['city'],
      state: json['state'],
      reviewData: json['review_data'] != null
          ? ReviewData.fromJson(json['review_data'])
          : null,
      isFavorite: json['is_favorite'] ?? false,
      category: List<int>.from(json['category'] ?? [], 
      ),
      propertyType: json["property_type"] == null ? null : Hoteltype.fromJson(json["property_type"]),
    );
  }
  // Map<String, dynamic> toJson() {
  //   return {
  //     'city_name': cityName,
  //     'checkin_date': checkinTime,
  //     'checkout_date': checkoutTime,
  //     'adults': adults,
  //     'children': children,
  //     'rating': rating,
  //     'amenities': amenities,
  //     'sorted': sorted,
  //     'filter': filter,
  //   };
  // }
}

class Amenity {
  final String name;
  final String icon;

  Amenity({
    required this.name,
    required this.icon,
  });

  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(
      name: json['amenity_name'],
      icon: json['icon_url'],
    );
  }
}

class PostPolicies {
  final Map<String, List<String>> policies;

  PostPolicies({
    required this.policies,
  });

  factory PostPolicies.fromJson(Map<String, dynamic> json) {
    return PostPolicies(
      policies: Map<String, List<String>>.from(json.map((key, value) {
        return MapEntry(key, List<String>.from(value));
      })),
    );
  }
}

class ChaletImage {
  final String imageUrl;
  final bool isMainImage;

  ChaletImage({
    required this.imageUrl,
    required this.isMainImage,
  });

  factory ChaletImage.fromJson(Map<String, dynamic> json) {
    return ChaletImage(
      imageUrl: json['image'],
      isMainImage: json['is_main_image'],
    );
  }
}

class ReviewData {
  int? numberOfReviews;
  int? numberOfRatings;
  List<Review>? reviews;
  double? avgRating;
  int? numbersOfTotal1Star;
  int? numbersOfTotal2Star;
  int? numbersOfTotal3Star;
  int? numbersOfTotal4Star;
  int? numbersOfTotal5Star;
  double? avgRatingLast6Months;

  ReviewData({
    this.numberOfReviews,
    this.numberOfRatings,
    this.reviews,
    this.avgRating,
    this.numbersOfTotal1Star,
    this.numbersOfTotal2Star,
    this.numbersOfTotal3Star,
    this.numbersOfTotal4Star,
    this.numbersOfTotal5Star,
    this.avgRatingLast6Months,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) => ReviewData(
        numberOfReviews: json["number_of_reviews"] ?? 0,
        numberOfRatings: json["number_of_ratings"] ?? 0,
        reviews: json["reviews"] == null
            ? []
            : List<Review>.from(
                json["reviews"]!.map((x) => Review.fromJson(x))),
        avgRating: json["avg_rating"] != null
            ? json["avg_rating"] > 0
                ? json["avg_rating"]
                : 5
            : 5,
        numbersOfTotal1Star: json["numbers_of_total_1_star"],
        numbersOfTotal2Star: json["numbers_of_total_2_star"],
        numbersOfTotal3Star: json["numbers_of_total_3_star"],
        numbersOfTotal4Star: json["numbers_of_total_4_star"],
        numbersOfTotal5Star: json["numbers_of_total_5_star"],
        avgRatingLast6Months: json["avg_rating_last_6_months"],
      );
}
