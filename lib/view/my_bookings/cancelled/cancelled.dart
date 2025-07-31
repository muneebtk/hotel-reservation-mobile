import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_concierge_tourism/constant/images/demo.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/upcoming_section_hotel/cancelled.dart';
import 'package:e_concierge_tourism/utils/date_time.dart';
import 'package:e_concierge_tourism/view/my_bookings/upcoming/view_more_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/styles/colors.dart';
import '../../../controller/api/upcoming_section/success_details.dart';
import '../../../controller/model/chalet_bookings/chalet_upcoming_section/chalet_upcoming.dart';

class Cancelled extends StatefulWidget {
  static const route = '/cancelledPage';

  const Cancelled({super.key});

  @override
  State<Cancelled> createState() => _CancelledState();
}

BookingSuccessApiDetails controller = Get.put(BookingSuccessApiDetails());

class _CancelledState extends State<Cancelled> {
  @override
  void initState() {
    controller.fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Obx(
        () {
          if (controller.loading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: darkRed,
              ),
            );
          }
          if (controller.mergedCancelledData.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/emptyImage/Group 1000001753.png'),
                  height20,
                  Text("There is no cancelled Hotel".tr),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.mergedCancelledData.length,
            itemBuilder: (context, index) {
              var booking = controller.mergedCancelledData[index];
              String image = '';
              String name = '';
              String checkinDate = '';
              String checkoutDate = '';
              double price = 0.0;

              if (booking is HotelBookingCancelled) {
                if (booking.hotelImage.isNotEmpty) {
                  image = booking.hotelImage.first;
                }
                name = booking.hotelName;
                checkinDate = dateTimeFormat(booking.checkinDate);
                checkoutDate = dateTimeFormat(booking.checkoutDate);
                price = booking.bookedPrice;
              } else if (booking is ChaletBookingUpcoming) {
                if (booking.chaletImages.isNotEmpty) {
                  image = booking.chaletImages[0];
                }
                name = booking.chaletName;
                checkinDate = dateTimeFormat(booking.checkinDate);
                checkoutDate = dateTimeFormat(booking.checkoutDate);
                price = booking.bookedPrice;
              }

              return InkWell(
                onTap: () {
                  Get.to(() {
                    if (booking is HotelBookingCancelled) {
                      return ViewMoreDetailsPage(
                        type: 'hotel',
                        propertyId: booking.id.toString(),
                      );
                    } else if (booking is ChaletBookingUpcoming) {
                      return ViewMoreDetailsPage(
                        type: 'chalet',
                        propertyId: booking.id.toString(),
                      );
                      // return ViewMoreDetailsPageChalet(
                      //   bookingID: booking.bookingId,
                      //   image: booking.chaletImages[0],
                      //   codeCompletedDetails: '1',
                      //   hotelId: booking.chaletId.toString(),
                      //   hotelName: name,
                      //   hotelcityname: booking.city,
                      //   checkindate: checkinDate,
                      //   checkout: checkoutDate,
                      //   guestInfo: guests.toString(),
                      //   userRating: booking.userRating,
                      // );
                    }
                    // Optionally handle the case when booking is neither HotelBookingUpcoming nor ChaletBookingUpcoming
                    return Container(); // Or some other fallback widget
                  });
                },
                child: Card(
                  color: kWhite,
                  elevation: 5,
                  child: Container(
                    color: kWhite,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: image.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: image,
                                        width: screenWidth * 0.4,
                                        height: screenWidth * 0.35,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
                                          child: Image.network(loadingImage),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        ),
                                      )
                                    : SizedBox(
                                        width: screenWidth * 0.4,
                                        height: screenWidth * 0.35,
                                        child: Image.network(
                                          loadingImage,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$checkinDate - $checkoutDate',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? kWhite // removes color if in dark theme
                                        : kBlack,
                                  ),
                                ),
                                SizedBox(
                                  height: screenWidth * 0.1,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '$price OMR +Tax',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? kWhite // removes color if in dark theme
                                                : kBlack),
                                      ),
                                    ),
                                    Text(
                                      "Cancelled".tr,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: darkRed),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
