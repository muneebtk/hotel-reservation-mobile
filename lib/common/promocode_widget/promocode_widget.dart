import 'dart:convert';

import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/review_page_notf.dart';
import 'package:e_concierge_tourism/getx/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/styles/colors.dart';
import '../../constant/styles/sizedbox.dart';
import '../../view/home/widgets/heading_text.dart';
import 'package:http/http.dart' as http;

class PromoCodeWidget extends StatefulWidget {
  const PromoCodeWidget(
      {super.key,
      required this.applyCode,
      required this.isApplied,
      required this.promocode,
      this.isChalet = false,
      required this.clear});
  final Function(PromoCodeCheckModel?) applyCode;
  final Function() clear;
  final bool isChalet;
  final bool isApplied;
  final String promocode;

  @override
  State<PromoCodeWidget> createState() => _PromoCodeWidgetState();
}

class _PromoCodeWidgetState extends State<PromoCodeWidget> {
  // final ApplyPromoController applyPromoController = Get.find();
  TextEditingController controller = TextEditingController();
  late RoomsController roomController;

  @override
  void initState() {
    super.initState();
    controller.text = widget.promocode;
    initialize();
  }

  initialize() {
    if (!widget.isChalet) roomController = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingText(heading: 'Add Promocode'.tr),
            height5,
            // Obx(() {
            //   return
            Row(children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: TextFormField(
                    controller: controller,
                    readOnly: widget.isApplied,
                    autofocus: false,
                    decoration: InputDecoration(
                      suffixIcon: widget.isApplied
                          ? IconButton(
                              onPressed: () {
                                // widget.isApplied = false;
                                controller.clear();
                                widget.clear();
                                // widget.applyCode(null);
                              },
                              icon: const Icon(Icons.close),
                            )
                          : null,
                      hintText: 'Apply promocode'.tr,
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      fillColor: kWhite,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide()),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: widget.isApplied
                    ? null
                    : () {
                        if (controller.text.isNotEmpty) {
                          // Focus.of(context).unfocus();
                          if (widget.isChalet) {
                            final model =
                                PromoCodeCheckModel(promocode: controller.text);
                            widget.applyCode(model);
                          } else {
                            final List<RoomWithMeal> roomsWithMeal =
                                roomController.roomsWithMeal.value;
                            final model = PromoCodeCheckModel(
                                rooms: roomsWithMeal,
                                promocode: controller.text);
                            widget.applyCode(model);
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kWhite,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  side:
                      const BorderSide(color: Color.fromARGB(255, 5, 22, 202)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: Text('Apply'.tr),
              )
            ]),
            // }),
          ],
        ));
  }
}

class ApplyPromoController extends GetxController {
  RxBool isapplied = false.obs;
  Future<double?> applyPromocode(PromoCodeCheckModel model) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final accessToken = pref.getString('access_token');
    var headers = {
      'Content-Type': 'application/json',
    };

    if (accessToken != null && accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    try {
      final response = await http.post(
        Uri.parse(applyPromo),
        headers: headers,
        body: jsonEncode(model),
      );
      print(jsonEncode(model));
      print(response.body);
      if (response.statusCode == 200) {
        isapplied.value = true;
        showAnimatedSnackBar(jsonDecode(response.body)['message'], kBlack);
        return (jsonDecode(response.body)['Total after discount']);
      } else {
        isapplied.value = false;
        showAnimatedSnackBar(
            jsonDecode(response.body)['message'] ?? 'Something went wrong'.tr,
            kRed);
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
