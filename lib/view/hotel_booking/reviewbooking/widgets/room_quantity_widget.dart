import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_concierge_tourism/common/capitalized_word/capitialize_word.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/images/demo.dart';

class RoomsQuantityWidget extends StatelessWidget {
  const RoomsQuantityWidget({
    super.key,
    required this.width,
    required this.roomName,
    required this.roomDescription,
    required this.codeNumCompleted,
    this.roomId,
    required this.roomImage,
    this.roomPrice,
    this.tax,
    this.check,
    this.discountPrice,
    this.totalAmount,
    this.length = 0,
    required this.index,
    this.mealPrice,
    this.mealTax,
    required this.nights,
    this.numberofRooms = 0,
  });

  final double width;
  final String roomImage;
  final String roomName;
  final String roomDescription;
  final String codeNumCompleted;
  final int? roomId;
  final String? check;
  final int length;
  final int index;

  final String? roomPrice;
  final String? tax;
  final double? mealPrice;
  final double? mealTax;
  final String? discountPrice;
  final String? totalAmount;
  final int? nights;
  final int numberofRooms;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        roomName.toUpperCase(),
                        style: TextStyle(
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(capitalizeFirstLetter(roomDescription),
                          style: TextStyle(fontSize: width * 0.03)),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: roomImage.isNotEmpty
                    ? ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        child: CachedNetworkImage(
                          imageUrl: roomImage,
                          placeholder: (context, url) => Center(
                            child: Image.network(loadingImage),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        ),
                      )
                    : Image.network(loadingImage),
              ),
              const SizedBox(width: 5),
              //   if (codeNumCompleted == '1' && roomId != null)
              // Obx(() => Checkbox(
              //       value: controller.roomCheckboxState[roomId]?.value ?? false,
              //       onChanged: (value) =>
              //           controller.toggleCheckbox(roomId!, value),
              //     )),
            ],
          ),
          if (check == "VIEW_MORE_DETAILS" && length - 1 == index)
            PriceWidget(
              nights: nights,
              isHotel: true,
              roomPrice: roomPrice,
              tax: tax,
              discountPrice: discountPrice,
              totalAmount: totalAmount,
              mealPrice: mealPrice ?? 0,
              mealTax: mealTax ?? 0,
              numberofRooms: numberofRooms,
            ),
        ],
      ),
    );
  }
}

class PriceWidget extends StatelessWidget {
  const PriceWidget(
      {super.key,
      required this.isHotel,
      required this.roomPrice,
      required this.tax,
      required this.discountPrice,
      required this.totalAmount,
      this.mealPrice = 0,
      this.mealTax = 0,
      this.nights,
      this.numberofRooms = 0});

  final bool isHotel;
  final String? roomPrice;
  final String? tax;
  final String? discountPrice;
  final String? totalAmount;
  final double mealPrice;
  final double mealTax;
  final int? nights;
  final int numberofRooms;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   roomName,
          //   style: textBoldblack,
          // ),
          height5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isHotel)
                Row(
                  children: [
                    Text('$numberofRooms x ${"Room Price".tr}'),
                    if (nights != null) Text(' ($nights ${'nights'.tr})')
                  ],
                )
              else
                Row(
                  children: [
                    Text("Chalet Price".tr),
                    if (nights != null) Text(' ($nights ${'nights'.tr})')
                  ],
                ),
              Text("$roomPrice OMR"),
            ],
          ),
          const Divider(),
          if (mealPrice > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("meal_price".tr),
                Text("$mealPrice OMR"),
              ],
            ),
            const Divider(),
          ],
          if (mealTax > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("meal_tax".tr),
                Text("$mealTax OMR"),
              ],
            ),
            const Divider(),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("tax_service_fees".tr),
              Text("$tax OMR"),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Discount Price".tr, style: const TextStyle()),
              Text("- $discountPrice OMR"),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("total_amount_paid".tr,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("$totalAmount OMR",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class RoomsControllerCheckBox extends GetxController {
  var roomCheckboxState = <int, RxBool>{}.obs;

  void initializeRoomState(int roomId) {
    if (!roomCheckboxState.containsKey(roomId)) {
      roomCheckboxState[roomId] = false.obs;
    }
  }

  void toggleCheckbox(int roomId, bool? value) {
    if (roomCheckboxState.containsKey(roomId)) {
      roomCheckboxState[roomId]!.value = value ?? false;
    }
  }

  List<int> getSelectedRooms() {
    return roomCheckboxState.entries
        .where((entry) => entry.value.value)
        .map((entry) => entry.key)
        .toList();
  }
}
