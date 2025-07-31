class PriceRangeModel {
  final double price;

  PriceRangeModel({required this.price});

  Map<String, dynamic> toJson() {
    return {
      'priceRange': price.toString(),
    };
  }
}
