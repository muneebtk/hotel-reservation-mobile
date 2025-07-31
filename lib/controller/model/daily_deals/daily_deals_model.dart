// Model---------------
class DailyDeal {
  final String title;
  final String description;
  final double? discountPercentage;
  final String chaletName;
  final String image;
  final String categorie;
  final String cityName;
  final double price;
  final int id;
  final int promotionId;
  final double discountedPrice;

  DailyDeal({
    required this.discountedPrice,
    required this.price,
    required this.cityName,
    required this.categorie,
    required this.id,
    required this.title,
    required this.description,
    this.discountPercentage,
    required this.chaletName,
    required this.image,
    required this.promotionId,
  });

  // Factory constructor to create a DailyDeal from JSON
  factory DailyDeal.fromJson(Map<String, dynamic> json) {
    return DailyDeal(
      discountedPrice: json['discounted_price'] ?? 0,
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : json['price'] ?? 45.0,
      categorie: json['data_type'] ?? 'Unknown',
      cityName: json['city'] ?? 'Unknown City',
      id: json['property_id'] ?? 0,
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      discountPercentage: double.parse(json['discount_percentage'] ?? '0'),
      chaletName: json['name'] ?? 'No Name',
      image: json['image'] ?? '',
      promotionId: json['promotion_id']
    );
  }
}
