import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_concierge_tourism/constant/images/demo.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/utils/date_time.dart';
import 'package:e_concierge_tourism/view/my_bookings/upcoming/cancellation_page.dart';
import 'package:e_concierge_tourism/view/my_bookings/upcoming/view_more_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/api/upcoming_section/success_details.dart';
import '../../../controller/model/chalet_bookings/chalet_upcoming_section/chalet_upcoming.dart';
import '../../../controller/model/hotel_bookings/upcoming_section_hotel/upcoming.dart';

class UpComingBookings extends StatefulWidget {
  const UpComingBookings({super.key});

  @override
  State<UpComingBookings> createState() => _UpComingBookingsState();
}

class _UpComingBookingsState extends State<UpComingBookings> {
  BookingSuccessApiDetails controller = Get.put(BookingSuccessApiDetails());

  @override
  void initState() {
    controller.fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Obx(() {
        if (controller.loading.value) {
          return const Center(
              child: CircularProgressIndicator(
            color: darkRed,
          ));
        } else if (controller.mergedUpcomingData.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/emptyImage/favourites.png'),
                height20,
                Text("There is no Upcoming Hotels".tr),
              ],
            ),
          );
        }

        //hotel and chalet Listing of upcoming

        return ListView.builder(
            itemCount: controller.mergedUpcomingData.length,
            itemBuilder: (context, index) {
              var booking = controller.mergedUpcomingData[index];
              String image = '';
              String name = '';
              String checkinDate = '';
              String checkoutDate = '';
              int guests = 0;
              double price = 0.0;

              if (booking is HotelBookingUpcoming) {
                // print(booking.status);

                if (booking.hotelImage.isNotEmpty) {
                  image = booking.hotelImage.first;
                }
                name = booking.hotelName;
                checkinDate = dateTimeFormat(booking.checkinDate);
                checkoutDate = dateTimeFormat(booking.checkoutDate);
                guests = booking.numberOfGuests;
                price = booking.bookedPrice;
              } else if (booking is ChaletBookingUpcoming) {
                if (booking.chaletImages.isNotEmpty) {
                  image = image = booking.chaletImages.first;
                }
                name = booking.chaletName;
                checkinDate = dateTimeFormat(booking.checkinDate);
                checkoutDate = dateTimeFormat(booking.checkoutDate);
                guests = booking.numberOfGuests;
                price = booking.bookedPrice;
              }

              return Card(
                elevation: 5,
                child: Container(
                  color: kWhite,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
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
                                  const SizedBox(height: 4),
                                  Text(
                                    "$guests ${"Guest".tr}",
                                    style: const TextStyle(
                                        fontSize: 13, color: kBlack),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "$price OMR",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: kBlack),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (booking.status != 'check-in')
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (booking is HotelBookingUpcoming) {
                                      Get.to(() => CancellationPage(
                                            type: 'hotel',
                                            propertyId:
                                                booking.hotelId.toString(),
                                            bookingId: booking.id.toString(),
                                          ));
                                    } else if (booking
                                        is ChaletBookingUpcoming) {
                                      Get.to(() => CancellationPage(
                                            type: 'chalet',
                                            bookingId: booking.id.toString(),
                                            propertyId:
                                                booking.chaletId.toString(),
                                          ));
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: darkRed),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Center(
                                      child: Text(
                                        'Cancel Booking'.tr,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: darkRed,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (booking is HotelBookingUpcoming) {
                                    Get.to(
                                      () => ViewMoreDetailsPage(
                                        type: 'hotel',
                                        propertyId: booking.id.toString(),
                                      ),
                                    );
                                  } else if (booking is ChaletBookingUpcoming) {
                                    Get.to(
                                      () => ViewMoreDetailsPage(
                                          type: 'chalet',
                                          propertyId: booking.id.toString()),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: darkRed,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: Text(
                                  'View More Details'.tr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }
}
