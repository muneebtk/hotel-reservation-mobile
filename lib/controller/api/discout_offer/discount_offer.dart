import 'dart:convert';

import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../model/discount_offer/discount_offer_model.dart';

class DiscountOfferApi extends GetxController {
  var discountOfferData = <TodayOffer>[].obs;
  var loading = false.obs;
  // Fetching daily deal offers

  void discountOffer() async {
    try {
      discountOfferData.clear();
      loading.value = true;
      final response = await http.get(Uri.parse("$baseUrl/api/today_offer/"));
      print('todays offer${response.body}');
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['today_offers'];
        discountOfferData.value =
            data.map((e) => TodayOffer.fromJson(e)).toList();
      } else {
        debugPrint('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching daily deals: ${e.toString()}');
    } finally {
      loading.value = false;
    }
  }
}
