import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/controller/api/authentication/login_controller.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/hotel_details.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constant/exception_message/exception_message.dart';

class HotelDetailsControllerApi extends GetxController {
  RxList reviewsList = [].obs;
  RxString message = "".obs;

  var hotelDetails = HotelDetailsData(
      id: 0,
      cancellationPolicy: [],
      vendorFirstName: "",
      cityName: "",
      countryName: "",
      stateName: "",
      price: 0,
      hotelImage: [],
      categoryName: [],
      roomtypeName: [],
      officeNumber: "",
      name: "",
      address: "",
      numberOfRooms: 0,
      roomsAvailable: 0,
      hotelRating: "",
      crNumber: "",
      vatNumber: "",
      dateOfExpiry: "",
      approved: false,
      hotelPolicies: '',
      logo: "",
      hotelId: "",
      aboutProperty: "",
      policies: {},
      locality: "",
      buildingNumber: "",
      postApproval: false,
      propertyTypes: [],
      amenities: [],
      numberRating: 0,
      numberReview: 0,
      avgrating: 0.0,
      total1star: 0,
      total2star: 0,
      total3star: 0,
      total4star: 0,
      total5star: 0,
      countryTax: 0.0,
      lat: 0,
      lng: 0,
      offers: [],
      promoCode: [],
      reviews: []).obs;

  // var latitude = 0.0.obs;
  // var longitude = 0.0.obs;
  var loading = false.obs;
  void fetchHotelDetail(String id, String checkinDate, String checkoutDate,
      int members, int room) async {
    try {
      loading.value = true;

      Timer(const Duration(seconds: 10), () {
        if (loading.value) {
          loading.value = false;
          message.value = "Taking too long, please try again.".tr;
          showAnimatedSnackBar(message.value, darkRed);
        }
      });
      SharedPreferences pref = await SharedPreferences.getInstance();
      var accessToken = pref.getString('access_token');
      final lang = await getLang();

      var headers = {
        'Content-Type': 'application/json',
      };

      if (accessToken != null && accessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $accessToken';
      }
      final response = await http.get(
          Uri.parse("${hotelDetailUrl}api/properties/$id")
              .replace(queryParameters: {
            "lang": lang,
            "checkin_date": checkinDate,
            "checkout_date": checkoutDate,
            "members": "$members",
            "room": "$room"
          }),
          headers: headers);
      log(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(utf8.decode(response.bodyBytes));

        final Map<String, dynamic> data = responseData['data'];

        HotelDetailsData fetchedDetails = HotelDetailsData.fromJson(data);
        hotelDetails.value = fetchedDetails;
        hotelDetails.value.price = responseData['price'] ?? 0;
        // hotelDetails.value.offers = responseData['offers'] != null
        //     ? List<Offer>.from(
        //         responseData['offers']?.map((x) => Offer.fromJson(x)))
        //     : [];
        // hotelDetails.value.promoCode = responseData['promo_code'] == null
        //     ? []
        //     : List<PromoCode>.from(
        //         responseData['promo_code']!.map((x) => PromoCode.fromJson(x)));
        List<dynamic> ad = responseData['offers'] ?? [];
        ad.addAll(responseData['promo_code']);
        hotelDetails.value.offers =
            List<Offer>.from(ad.map((x) => Offer.fromJson(x)));

        hotelDetails.value.address = hotelDetails.value.cityName;
        if (hotelDetails.value.stateName.isNotEmpty) {
          hotelDetails.value.address += ', ${hotelDetails.value.stateName}';
        }
        if (hotelDetails.value.countryName.isNotEmpty) {
          hotelDetails.value.address += ', ${hotelDetails.value.countryName}';
        }
        // List<Location> locations =
        //     await locationFromAddress(hotelDetails.value.address);
        reviewsList.assignAll(data['reviews']);

        loading.value = false;
        // if (locations.isNotEmpty) {
        //   latitude.value = locations[0].latitude;
        //   longitude.value = locations[0].longitude;
        // } else {
        //   debugPrint("${response.statusCode}");
        // }
      } else {
        if (response.statusCode == 401 && accessToken != null) {
          final success = await LoginController().refToken();
          if (success) {
            return fetchHotelDetail(
                id, checkinDate, checkoutDate, members, room);
          }
        } else {
          message.value = jsonDecode(response.body)['message'];
        }
      }
    } catch (e) {
      print('ERROR   $e');
      message.value = handleHttpException(e);
      throw Exception(handleHttpException(e));
    } finally {
      loading.value = false;
    }
  }
}
