import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_concierge_tourism/common/capitalized_word/capitialize_word.dart';
import 'package:e_concierge_tourism/constant/images/demo.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/hotel_list_model.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:e_concierge_tourism/view/hotel_booking/reviewbooking/widgets/room_quantity_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../constant/styles/colors.dart';
import '../../../../constant/styles/textstyle.dart';

class ReviewHotel extends StatelessWidget {
  final String hotelName;
  final String image;
  final String morningDays;
  final String nightDays;
  final String checkIndate;
  final String checkoutdate;
  final String guestInfo;
  final String hotelCityName;
  final String? chaletCheck;
  final String? price;
  final String? tax;
  final String? discountPrice;
  final String? totalAmount;
  final DateTime? checkinDate;
  final DateTime? checkoutDate;
  final String hotelRating;
  final Hoteltype? propertyType;

  const ReviewHotel({
    super.key,
    required this.width,
    required this.height,
    required this.checkIndate,
    required this.checkoutdate,
    required this.guestInfo,
    required this.morningDays,
    required this.nightDays,
    required this.image,
    required this.hotelName,
    required this.hotelCityName,
    required this.hotelRating,
    this.chaletCheck,
    this.price,
    this.tax,
    this.discountPrice,
    this.totalAmount,
    this.checkinDate,
    this.checkoutDate,
    this.propertyType,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                      hotelName,
                      style: TextStyle(
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Wrap(
                        runSpacing: 5,
                        children: [
                          if (hotelRating.isNotEmpty)
                            Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: getPropertyStarIcon(hotelRating),
                                  width: 20,
                                  height: 20,
                                ),
                                width5,
                                Expanded(
                                  child: Text(
                                    showPropertyStarText(hotelRating),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (propertyType?.icon != null &&
                              propertyType?.type != null)
                            Row(
                              children: [
                                CachedNetworkImage(
                                  width: 20,
                                  height: 20,
                                  imageUrl: propertyType!.icon!,
                                  errorWidget: (context, url, error) =>
                                      const SizedBox.shrink(),
                                ),
                                // Image.network(
                                //   propertyType!.icon!,
                                //   width: 20,
                                //   height: 20,
                                // ),
                                width5,
                                Expanded(
                                  child: Text(
                                    propertyType!.type!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                width10,
                              ],
                            ),
                        ],
                      ),
                    ),
                    // Row(
                    //   children: getHotelRating(hotelRating),
                    // ),
                    SizedBox(height: height * 0.01),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: width * 0.05),
                        Expanded(
                          child: Text(capitalizeFirstLetter(hotelCityName),
                              style: TextStyle(fontSize: width * 0.03)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: image.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: chaletCheck == 'CHALET' ? image : image,
                        placeholder: (context, url) => Center(
                          child: Image.network(loadingImage),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      )
                    : Image.network(loadingImage),

                // Image.network(
                //   chaletCheck == 'CHALET' ? image : image,
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            const SizedBox(
              width: 5,
            )
          ],
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "checkin".tr,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(checkIndate),
                    if (checkinDate != null)
                      Text(
                        '${'Check-In'.tr} - ${DateFormat('hh:mm a').format(checkinDate!.toLocal())}',
                        style: const TextStyle(fontSize: 10),
                      )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: kBlue),
                  shape: BoxShape.rectangle,
                  color: Colors.lightBlue[100],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        nightDays,
                        style: const TextStyle(fontSize: 8),
                      ),
                      const Text(
                        "&",
                        style: TextStyle(fontSize: 8),
                      ),
                      Text(
                        morningDays,
                        style: const TextStyle(fontSize: 7),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "checkout".tr,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(checkoutdate),
                    if (checkoutDate != null)
                      Text(
                        '${'Check-Out'.tr} - ${DateFormat('hh:mm a').format(checkoutDate!.toLocal())}',
                        style: const TextStyle(fontSize: 10),
                      )
                  ],
                ),
              )
            ],
          ),
        ),
        const Divider(),
        ListTile(
          subtitle: Text(
            guestInfo,
            style: textBoldblack,
          ),
          title: Text(
            "Room_members".tr,
            style: const TextStyle(color: kGrey),
          ),
        ),
        if (chaletCheck == 'CHALET') const Divider(),
        chaletCheck == 'CHALET'
            ? PriceWidget(
                isHotel: false,
                roomPrice: price,
                tax: tax,
                discountPrice: discountPrice,
                totalAmount: totalAmount,
              )
            // Obx(() {
            //     // var booking = bookingController.mergedUpcomingData[0];

            //     return ListTile(
            //       trailing: const Text(
            //         "₹ ${100}",
            //         style: textBoldblack,
            //       ),
            //       title: Text(
            //         "Booked price".tr,
            //         style: const TextStyle(color: kGrey, fontSize: 13),
            //       ),
            //     );
            //   })
            : const SizedBox(),
      ],
    );
  }

  List<Widget> getHotelRating(String rating) {
    final parsedRating = int.parse(rating.isNotEmpty ? rating : '0');
    final ratingList = <Widget>[];
    for (var i = 0; i < parsedRating; i++) {
      ratingList.add(const Icon(
        Icons.star,
        color: Colors.amber,
        size: 13,
      ));
    }
    return ratingList;
  }
}
