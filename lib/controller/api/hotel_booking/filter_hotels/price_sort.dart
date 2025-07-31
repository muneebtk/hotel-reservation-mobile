import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../model/hotel_bookings/filter_hotel_model/price_range.dart';

class PriceRangeController extends GetxController {
  var price = 0.0.obs;

  void updatePrice(double value) {
    price.value = value;
  }

  Future<void> sendSelectedPriceRange() async {
    final priceRangeModel = PriceRangeModel(price: price.value);
    final response = await http.post(
      Uri.parse('https://your-backend-api-url.com/price-range'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(priceRangeModel.toJson()),
    );

    if (response.statusCode == 200) {
      debugPrint('Price range sent successfully');
    } else {
      debugPrint('Failed to send price range');
    }
  }
}
