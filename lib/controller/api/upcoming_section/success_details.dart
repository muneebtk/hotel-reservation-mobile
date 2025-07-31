import 'dart:async';
import 'dart:developer';

import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../constant/api_service/api_url.dart';
import '../../../constant/styles/colors.dart';
import '../../model/chalet_bookings/chalet_upcoming_section/chalet_upcoming.dart';
import '../../model/hotel_bookings/upcoming_section_hotel/cancelled.dart';
import '../../model/hotel_bookings/upcoming_section_hotel/completed.dart';
import '../../model/hotel_bookings/upcoming_section_hotel/upcoming.dart';
import '../../../constant/exception_message/exception_message.dart';
import '../authentication/login_controller.dart';

//Upcoming / completed / cancelled

class BookingSuccessApiDetails extends GetxController {
  var loading = false.obs;
  var message = ''.obs;

  //*merging============= merging both chalet and hotel list

  RxList<dynamic> mergedUpcomingData = <dynamic>[].obs;
  RxList<dynamic> mergedCancelledData = <dynamic>[].obs;
  RxList<dynamic> mergedCompletedData = <dynamic>[].obs;

  //====== chalet list empty

  RxList<ChaletBookingUpcoming> upcomingChaletdata =
      <ChaletBookingUpcoming>[].obs;
  RxList<ChaletBookingUpcoming> cancelledChalet = <ChaletBookingUpcoming>[].obs;
  RxList<ChaletBookingUpcoming> completedChalet = <ChaletBookingUpcoming>[].obs;

  //----- hotel list empty
  RxList<HotelBookingUpcoming> upComingData = <HotelBookingUpcoming>[].obs;
  RxList<HotelBookingCompleted> completedData = <HotelBookingCompleted>[].obs;
  RxList<HotelBookingCancelled> cancelledData = <HotelBookingCancelled>[].obs;

  void fetchData({bool retry = true}) async {
    loading.value = true;

    // when failing there are network delays

    Timer(const Duration(seconds: 10), () {
      if (loading.value) {
        loading.value = false;
        message.value = "Taking too long, please try again.".tr;
        showAnimatedSnackBar(message.value, darkRed);
      }
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    final lang = await getLang();
    var accessToken = pref.getString('access_token');

    const chaletUrl = upcomingChaletUrl;
    const url = "${upcominUrl}api/properties/book-list";

    try {
      final response = await http.get(
          Uri.parse(url).replace(queryParameters: {"lang": lang}),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          });
      log((response.body));
      final chaletResponse = await http.get(
          Uri.parse(chaletUrl).replace(queryParameters: {"lang": lang}),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          });
      log(chaletResponse.body);
      loading.value = false;
      if (response.statusCode == 200 && chaletResponse.statusCode == 200) {
        upComingData.clear();
        upcomingChaletdata.clear();
        cancelledChalet.clear();
        mergedUpcomingData.clear();
        mergedCancelledData.clear();

        final Map<String, dynamic> responseBody =
            json.decode(utf8.decode(response.bodyBytes));
        final Map<String, dynamic> chaletResponseBody =
            json.decode(utf8.decode(chaletResponse.bodyBytes));

        final List<dynamic>? responseData = responseBody['upcoming_data_hotel'];
        final List<dynamic>? responseData2 =
            responseBody['Completed_data_hotel'];
        final List<dynamic>? responseData3 = responseBody['Canceled'];
        //--------
        final List<dynamic>? chaletUpcomingData =
            chaletResponseBody['upcoming_data_chalet'];
        final List<dynamic>? chaletCancelledData =
            chaletResponseBody['canceled'];

        final List<dynamic>? chaletCompletedData =
            chaletResponseBody['completed_data_chalet'];
//-----------------------------------------------------------------------------------
        //adding upcoming data in upcoming list
        // upComingData.assignAll([data]);
        if (responseData != null) {
          upComingData.assignAll(
            responseData
                .map((hotelJson) => HotelBookingUpcoming.fromJson(hotelJson))
                .toList(),
          );
        }
        //adding completed data in completed list

        if (responseData2 != null) {
          completedData.assignAll(
            responseData2
                .map((hotelJson) => HotelBookingCompleted.fromJson(hotelJson))
                .toList(),
          );
        }
        //adding cancelled data in cancelled list

        if (responseData3 != null) {
          cancelledData.assignAll(
            responseData3
                .map((hotelJson) => HotelBookingCancelled.fromJson(hotelJson))
                .toList(),
          );
        }
        //---------------------- same as hotel

        //chalet
        if (chaletUpcomingData != null) {
          upcomingChaletdata.assignAll(
            chaletUpcomingData
                .map((chaletJson) => ChaletBookingUpcoming.fromJson(chaletJson))
                .toList(),
          );
        }
        if (chaletCancelledData != null) {
          cancelledChalet.assignAll(
            chaletCancelledData
                .map((chaletJson) => ChaletBookingUpcoming.fromJson(chaletJson))
                .toList(),
          );
        }
        if (chaletCompletedData != null) {
          completedChalet.assignAll(
            chaletCompletedData
                .map((chaletJson) => ChaletBookingUpcoming.fromJson(chaletJson))
                .toList(),
          );
        }
        //------------- merging both (hotel & chalet) upcoming/completed/cancelled list

        mergedUpcomingData.assignAll([...upComingData, ...upcomingChaletdata]);
        mergedCancelledData.assignAll([...cancelledData, ...cancelledChalet]);
        mergedCompletedData.assignAll([...completedData, ...completedChalet]);
      } else {
        if (response.statusCode == 401 && chaletResponse.statusCode == 401) {
          if (retry) {
            final success = await LoginController().refToken();
            if (success) {
              return fetchData(retry: false);
            }
          } else {
            // debugPrint('Invalid login credentials');
          }
        } else {
          message.value =
              jsonDecode(response.body)['message'] ?? 'Something went wrong'.tr;
          // debugPrint("${response.statusCode}");
        }
      }
    } catch (e) {
      // print(e);
      throw Exception(handleHttpException(e));
    } finally {
      loading.value = false;
    }
  }
}
