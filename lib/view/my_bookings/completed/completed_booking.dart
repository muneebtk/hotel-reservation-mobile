import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_concierge_tourism/constant/images/demo.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/controller/api/upcoming_section/success_details.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/upcoming_section_hotel/completed.dart';
import 'package:e_concierge_tourism/utils/date_time.dart';
import 'package:e_concierge_tourism/view/my_bookings/completed/view_more_details_chalet.dart';
import 'package:e_concierge_tourism/view/my_bookings/upcoming/view_more_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/model/chalet_bookings/chalet_upcoming_section/chalet_upcoming.dart';

class MyBookingsSuccess extends StatefulWidget {
  const MyBookingsSuccess({super.key});

  @override
  State<MyBookingsSuccess> createState() => _MyBookingsSuccessState();
}

class _MyBookingsSuccessState extends State<MyBookingsSuccess> {
  final BookingSuccessApiDetails controller =
      Get.put(BookingSuccessApiDetails());

  @override
  void initState() {
    super.initState();
    controller.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Obx(() {
      if (controller.loading.value) {
        return const Center(
            child: CircularProgressIndicator(
          color: darkRed,
        ));
      } else if (controller.mergedCompletedData.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/emptyImage/Group 1000001752.png'),
              height20,
              Text("There is no Hotel".tr),
            ],
          ),
        );
      }
      return Obx(() {
        // print(controller.mergedCompletedData[0]);
        return ListView.builder(
            itemCount: controller.mergedCompletedData.length,
            itemBuilder: (context, index) {
              // final data = controller.mergedCompletedData[index];
              var booking = controller.mergedCompletedData[index];
              String image = '';
              String name = '';
              String checkinDate = '';
              String checkoutDate = '';
              int guests = 0;
              double price = 0.0;

              if (booking is HotelBookingCompleted) {
                if (booking.hotelImage.isNotEmpty) {
                  image = booking.hotelImage.first;
                }
                name = booking.hotelName;
                checkinDate = dateTimeFormat(booking.checkinDate);
                checkoutDate = dateTimeFormat(booking.checkoutDate);
                guests = booking.numberOfGuests;
                price = booking.bookedprice;
              } else if (booking is ChaletBookingUpcoming) {
                if (booking.chaletImages.isNotEmpty) {
                  image = booking.chaletImages.first;
                }
                name = booking.chaletName;
                checkinDate = dateTimeFormat(booking.checkinDate);
                checkoutDate = dateTimeFormat(booking.checkoutDate);
                guests = booking.numberOfGuests;
                price = booking.bookedPrice;
              }

              return Card(
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    Get.to(() {
                      if (booking is HotelBookingCompleted) {
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

                  // onTap: () {
                  //   Get.to(() {
                  //     if (booking is HotelBookingUpcoming ||
                  //         booking is ChaletBookingUpcoming) {
                  //       ViewMoreDetailsPage(
                  //           image: booking.roomDetails[index].roomImages[index],
                  //           codeCompletedDetails: '1',
                  //           hotelId: booking.hotelId.toString(),
                  //           roomDetails: booking.roomDetails,
                  //           hotelName: name,
                  //           hotelcityname: booking.city,
                  //           morningdays: booking.numberOfMorning.toString(),
                  //           nightdays: booking.numberOfNight.toString(),
                  //           checkindate: checkinDate,
                  //           checkout: checkoutDate,
                  //           guestInfo: guests.toString());
                  //     }
                  //   });
                  // },
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
                                child: CachedNetworkImage(
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
                                ),
                              ),
                              const Positioned(
                                top: 8,
                                left: 8,
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 24,
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
                                  name.toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$checkinDate - $checkoutDate',
                                  style: const TextStyle(
                                      fontSize: 12, color: kBlack),
                                ),
                                SizedBox(
                                  height: screenWidth * 0.1,
                                ),
                                Text(
                                  "${price.toString()} OMR",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
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
            });
      });
    });
  }
}
