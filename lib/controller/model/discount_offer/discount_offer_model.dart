//model

class TodayOffer {
  final String title;
  final String description;
  final String discountPercentage;
  final bool freeNightOffer;
  final String startDate;
  final String endDate;
  final String? promoCode;
  final String? chaletName;
  final String? hotelName;
  final String? type;
  final num? minSpend;

  TodayOffer({
    required this.title,
    required this.description,
    required this.discountPercentage,
    required this.freeNightOffer,
    required this.startDate,
    required this.endDate,
    this.minSpend,
    this.promoCode,
    this.chaletName,
    this.hotelName,
    this.type,
  });

  factory TodayOffer.fromJson(Map<String, dynamic> json) {
    return TodayOffer(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      discountPercentage: json['discount_percentage'] != null
          ? json['discount_percentage'].toString()
          : '0.0',
      freeNightOffer: json['free_night_offer'] ?? false,
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      promoCode: json['promo_code'],
      chaletName: json['chalet_name'],
      hotelName: json['hotel_name'],
      type: json['category'],
      minSpend: json['minimum_spend'],
    );
  }
}
