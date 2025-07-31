import 'dart:convert';
import 'dart:io';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/controller/model/daily_deals/featured_hotel/featured_hotel_model.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeaturedHotelApi extends GetxController {
  var featuredHotels = <FeaturedData>[].obs;
  var loading = false.obs;
  void getFeaturedHotels() async {
    loading.value = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString('access_token');
    final lang = await getLang();
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/featured")
            .replace(queryParameters: {"lang": lang}),
      );
      print('featured hotel${response.body}');

      if (response.statusCode == 200) {
        final data = featuredHotelFromJson(utf8.decode(response.bodyBytes));

        featuredHotels.value = data.data ?? [];
      }
    } catch (e) {
      print(e);
      throw Exception(HttpException(e.toString()));
    } finally {
      loading.value = false;
    }
  }
}
