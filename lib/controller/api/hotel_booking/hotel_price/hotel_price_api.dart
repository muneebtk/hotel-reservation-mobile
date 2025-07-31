import 'dart:convert';

import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/controller/api/authentication/login_controller.dart';
import 'package:e_concierge_tourism/controller/api/payment_accepted_check/payment_types_check.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/booking_price_response.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/review_page_notf.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HotelPriceApi extends GetxController {
  var loading = false.obs;
  var message = ''.obs;
  var priceData = PriceData(
    roomPriceWithMealAndNumberOfRoomsAndNumberOfDays: 0,
    totalRoomsPriceWithTax: 0,
    discountPrice: 0,
    taxAndServices: 0,
    totalAmountToBePaid: 0,
    acceptedPayments: null,
  ).obs;
  final PaymentTypesCheck paymentTypesCheckController =
      Get.put(PaymentTypesCheck());
  void getBookingPriceDetails(
      List<RoomWithMeal> room, String startDate, String endDate, int? id,
      {bool isHotel = true,
      int? roomCount,
      int? chaletId,
      int? hotelId,
      String? promocode}) async {
    try {
      loading.value = true;
      final lang = await getLang();
      SharedPreferences pref = await SharedPreferences.getInstance();
      var accessToken = pref.getString('access_token');

      var headers = {
        'Content-Type': 'application/json',
      };

      if (accessToken != null && accessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $accessToken';
      }
      Map<String, Object> body;
      if (isHotel) {
        body = {
          if (roomCount != null) "count": roomCount,
          "rooms": room,
          "checkin_date": startDate,
          "checkout_date": endDate,
          if (promocode != null && promocode.isNotEmpty) "promocode": promocode,
          if (id != null) "promotion_id": id
        };
      } else {
        body = {
          "chalet": chaletId!,
          "checkin_date": startDate,
          "checkout_date": endDate,
          if (promocode != null && promocode.isNotEmpty) "promocode": promocode,
          if (id != null) "promotion_id": id
        };
      }

      // print(jsonEncode(body));
      final response = await http.post(
        Uri.parse(bookingPriceDetailsUrl)
            .replace(queryParameters: {"lang": lang}),
        headers: headers,
        body: jsonEncode(body),
      );
      await paymentTypesCheckController.checkPaymentTypesAccepted(
          isHotel ? hotelId : chaletId, isHotel ? 'hotel' : 'chalet');
      print(response.body);
      // print(response.statusCode);
      if (response.statusCode == 200) {
        final data =
            bookingPriceResponseFromJson(utf8.decode(response.bodyBytes));
        if (data.data != null) {
          priceData.value = data.data!;
          priceData.value.acceptedPayments =
              paymentTypesCheckController.paymentMethodsAccepted;
          if (data.data?.promocode != null &&
              (data.data?.promocode?.isNotEmpty ?? false)) {
            showAnimatedSnackBar(
                data.data?.message ?? 'Something went wrong'.tr, kBlack);
          }
        }
      } else if (response.statusCode == 401 && accessToken != null) {
        final success = await LoginController().refToken();
        if (success) {
          return getBookingPriceDetails(room, startDate, endDate, id,
              roomCount: roomCount,
              isHotel: isHotel,
              chaletId: chaletId,
              hotelId: hotelId,
              promocode: promocode);
        }
      } else {
        message.value = jsonDecode(response.body)['message'];
      }
    } catch (e) {
      print(e);
      message.value = 'Something went wrong'.tr;
    } finally {
      loading.value = false;
    }
  }
}
