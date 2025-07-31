import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/controller/api/authentication/login_controller.dart';
import 'package:e_concierge_tourism/constant/exception_message/exception_message.dart';
import 'package:e_concierge_tourism/controller/model/chalet_bookings/chalet_booking_entire/search_list.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/hotel_details.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constant/styles/colors.dart';
import '../../../model/chalet_bookings/chalet_booking_entire/chalet_searching.dart';

class ChaletSearchApi extends GetxController {
  RxList<ChaletSearchRequestModel> chaletList =
      <ChaletSearchRequestModel>[].obs;
  RxList<ChaletModel> chaletListDetail = <ChaletModel>[].obs;
  RxList<Offer> offers = <Offer>[].obs;
  var loading = false.obs;
  var message = ''.obs;
  // var latitude = 0.0.obs;
  // var longitude = 0.0.obs;
  RxList allAmanities = [].obs;

  Future<bool> fetchChalets(ChaletSearchRequestModel chaletSearchModel) async {
    loading.value = true;

    Timer(const Duration(seconds: 10), () {
      if (loading.value) {
        loading.value = false;
        message.value = "Taking too long, please try again.".tr;
        showAnimatedSnackBar(message.value, darkRed);
      }
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString('access_token');
    final lang = await getLang();
    try {
      var headers = {
        'Content-Type': 'application/json',
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
      print('chalet search model ${jsonEncode(chaletSearchModel.toJson())}');
      final response = await http.post(
          Uri.parse(
            "$baseUrl/api/sort-chalets/",
          ).replace(queryParameters: {"lang": lang}),
          headers: headers,
          body: jsonEncode(chaletSearchModel.toJson()));
      log(response.body);

      if (response.statusCode == 200) {
        var data = json.decode(utf8.decode(response.bodyBytes));

        chaletList.assignAll(
          (data['chalets'] as List)
              .map((item) => ChaletSearchRequestModel.fromJson(item))
              .toList(),
        );
        // print('${chaletList.first.toJson()}');

        allAmanities.assignAll(data['available_amenities']);
        loading.value = false;
        return true;
      } else if (response.statusCode == 401) {
        final success = await LoginController().refToken();
        if (success) {
          return fetchChalets(
            chaletSearchModel,
          );
        }
      } else {
        debugPrint('Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Exception: $e');
      message.value = handleHttpException(e);
    } finally {
      loading.value = false;
    }
    return false;
  }

  //*===============================================================================================================

//fetching chalet details data--------

  Future<bool> fetchChaletDetail(
      int id, String checkinDate, String checkoutDate, String cityname) async {
    loading.value = true;

    Timer(const Duration(seconds: 10), () {
      if (loading.value) {
        loading.value = false;
        message.value = "Login took too long, please try again.";
        Get.snackbar("Timeout", message.value,
            colorText: kWhite, backgroundColor: darkRed);
      }
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString('access_token');
    final lang = await getLang();
    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    try {
      final response = await http.get(
          Uri.parse("$baseUrl/api/chalets/$id").replace(queryParameters: {
            "lang": lang,
            "checkin_date": checkinDate,
            "checkout_date": checkoutDate,
            // "city__name": cityname,
          }),
          headers: headers);
      log(response.body);

      if (response.statusCode == 200) {
        var data = json.decode(utf8.decode(response.bodyBytes));
        ChaletModel chaletDetail = ChaletModel.fromJson(data);

        List<dynamic> ad = data['offers'];
        ad.addAll(data['promo_codes']);
        chaletDetail.offers =
            List<Offer>.from(ad.map((x) => Offer.fromJson(x)));
        chaletListDetail.assign(chaletDetail);

        chaletDetail.address = chaletDetail.cityName ?? '';
        if (chaletDetail.stateName?.isNotEmpty ?? false) {
          chaletDetail.address += ', ${chaletDetail.stateName}';
        }
        if (chaletDetail.countryName?.isNotEmpty ?? false) {
          chaletDetail.address += ', ${chaletDetail.countryName}';
        }
        return true;
      } else if (response.statusCode == 401) {
        final success = await LoginController().refToken();
        if (success) {
          return fetchChaletDetail(id, checkinDate, checkoutDate, cityname);
        }
        return false;
      } else {
        message.value =
            jsonDecode(response.body)['message'] ?? 'An error occurred';
        debugPrint('Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Exception: $e');
      message.value = handleHttpException(e);
      return false;
    } finally {
      loading.value = false;
    }
  }
}
