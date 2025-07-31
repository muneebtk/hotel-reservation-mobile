import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/daily_deals/daily_deals_model.dart';

class DailyDealsOfferApi extends GetxController {
  var dailyDealsData = <DailyDeal>[].obs;
  var loading = false.obs;
  void dailyDealseOffer() async {
    loading.value = true;
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // final token = pref.getString('access_token');
    try {
      dailyDealsData.clear();
      final response = await http.get(
        Uri.parse("$baseUrl/api/daily_deals/"),

        //      headers: {
        //   'Authorization': 'Bearer $token',
        //   'Content-Type': 'application/json',
        // }
      );
      log('daily deals${response.body}');
      if (response.statusCode == 200) {
        // print('dailydeals successsss ${response.body}');
        List<dynamic> jsonresponse =
            jsonDecode(utf8.decode(response.bodyBytes))['best_hotel'] ?? [];
        print(jsonresponse);
        // jsonresponse.add(jsonDecode(response.body)['best_chalet'] ?? []);
        print(jsonDecode(response.body)['best_hotel']);
        dailyDealsData.value =
            jsonresponse.map((e) => DailyDeal.fromJson(e)).toList();
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
      throw Exception(HttpException(e.toString()));
    } finally {
      loading.value = false;
    }
  }
}
