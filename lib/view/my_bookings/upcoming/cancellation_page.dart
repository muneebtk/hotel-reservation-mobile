import 'package:e_concierge_tourism/common/capitalized_word/capitialize_word.dart';
import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:e_concierge_tourism/controller/api/cancel_booking/cancel_booking.dart';
import 'package:e_concierge_tourism/controller/api/upcoming_section/booking_detail_controller.dart';
import 'package:e_concierge_tourism/controller/service/push_notification/push_notification_api.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/cancel_booking/cancel_booking_model.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/upcoming_section_hotel/rooms_details.dart';
import 'package:e_concierge_tourism/utils/date_time.dart';
import 'package:e_concierge_tourism/view/bottom_nav.dart/bottom_nav.dart';
import 'package:e_concierge_tourism/common/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/styles/colors.dart';
import '../../../constant/styles/sizedbox.dart';
import '../../../controller/api/upcoming_section/success_details.dart';
import '../../../controller/model/chalet_bookings/chalet_upcoming_section/chalet_upcoming.dart';
import '../../hotel_booking/reviewbooking/widgets/review_hotel.dart';
import '../../hotel_booking/reviewbooking/widgets/room_quantity_widget.dart';
import 'widget/reason_cancellation.dart';

class CancellationPage extends StatefulWidget {
  final String propertyId;
  final String bookingId;
  final String type;

  const CancellationPage({
    super.key,
    required this.propertyId,
    required this.bookingId,
    required this.type,
  });

  @override
  State<CancellationPage> createState() => _CancellationPageState();
}

class _CancellationPageState extends State<CancellationPage> {
  late BookingDetailApiController bookingController;

  @override
  void initState() {
    super.initState();
    Get.put(RoomsControllerCheckBox());
    bookingController = Get.put(BookingDetailApiController());
    bookingController.getBookingDetails(widget.bookingId, widget.type);
    // for (var room in widget.roomDetails) {
    //   Get.find<RoomsControllerCheckBox>().initializeRoomState(room.roomId);
    // }
  }

  final CancellationController controller = Get.put(CancellationController());
  final chaletCancellationController = Get.put(CancelBookingApiCHALET());
  final BookingSuccessApiDetails controllers = Get.find();

  final RoomsControllerCheckBox roomsController =
      Get.put(RoomsControllerCheckBox());
  final CancelBookingApi cancelBookingApiController =
      Get.put(CancelBookingApi());
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            bookingController.bookingDetails.value.value?.propertyDetails?.name
                    ?.toUpperCase() ??
                '',
            style: textBoldblack,
          ),
        ),
        body: bookingController.loading.value
            ? const Center(child: CircularProgressIndicator())
            : bookingController.bookingDetails.value.value != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.white,
                          child: ReviewHotel(
                            propertyType: bookingController.bookingDetails.value
                                .value?.propertyDetails?.propertyType,
                            hotelRating: bookingController.bookingDetails.value
                                    .value?.propertyDetails?.hotelRating ??
                                '',
                            checkinDate: bookingController
                                .bookingDetails.value.value?.checkin,
                            checkoutDate: bookingController
                                .bookingDetails.value.value?.checkout,
                            price: bookingController
                                .bookingDetails.value.value?.bookedPrice
                                .toString(),
                            discountPrice: bookingController
                                .bookingDetails.value.value?.discountAmount
                                .toString(),
                            tax: bookingController
                                .bookingDetails.value.value?.taxAmount
                                .toString(),
                            totalAmount: bookingController
                                    .bookingDetails.value.value?.bookedPrice
                                    .toString() ??
                                '',
                            chaletCheck: bookingController
                                .bookingDetails.value.value?.type,
                            hotelCityName: bookingController.bookingDetails
                                    .value.value?.propertyDetails?.city
                                    ?.toUpperCase() ??
                                '',
                            hotelName: bookingController.bookingDetails.value
                                    .value?.propertyDetails?.name
                                    ?.toUpperCase() ??
                                '',
                            image: bookingController.bookingDetails.value.value
                                    ?.propertyDetails?.image ??
                                '',
                            morningDays:
                                "${bookingController.bookingDetails.value.value?.numberOfMorning} ${"mornings".tr}",
                            nightDays:
                                "${bookingController.bookingDetails.value.value?.numberOfNight} ${"nights".tr}",
                            width: width,
                            height: height,
                            checkIndate: dateTimeFormat(
                                bookingController
                                    .bookingDetails.value.value?.checkin
                                    ?.toIso8601String(),
                                format: 'dd MMM y, EEE'),
                            checkoutdate: dateTimeFormat(
                                bookingController
                                    .bookingDetails.value.value?.checkout
                                    ?.toIso8601String(),
                                format: 'dd MMM y, EEE'),
                            guestInfo:
                                "${bookingController.bookingDetails.value.value?.numberOfRooms} Rooms & ${bookingController.bookingDetails.value.value?.guestCount} Members",
                          ),
                        ),
                        height10,
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: kWhite,
                          child: ListView.separated(
                            separatorBuilder: (context, index) => height10,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: bookingController.bookingDetails.value
                                    .value?.roomTypes?.length ??
                                0,
                            itemBuilder: (context, index) =>
                                RoomsQuantityWidget(
                              numberofRooms: bookingController.bookingDetails
                                      .value.value?.numberOfRooms ??
                                  0,
                              nights: bookingController
                                  .bookingDetails.value.value?.numberOfNight,
                              index: index,
                              length: bookingController.bookingDetails.value
                                      .value?.roomTypes?.length ??
                                  0,
                              check: "VIEW_MORE_DETAILS",
                              discountPrice: bookingController
                                  .bookingDetails.value.value?.discountAmount
                                  .toString(),
                              roomPrice: getRoomPrice().toString(),
                              tax: bookingController
                                  .bookingDetails.value.value?.taxAmount
                                  .toString(),
                              mealPrice: bookingController
                                  .bookingDetails.value.value?.mealPrice,
                              mealTax: bookingController
                                  .bookingDetails.value.value?.mealTax,
                              totalAmount: bookingController
                                      .bookingDetails.value.value?.bookedPrice
                                      .toString() ??
                                  '',
                              roomImage: bookingController.bookingDetails.value
                                      .value?.roomTypes?[index].image ??
                                  '',
                              roomId: bookingController.bookingDetails.value
                                  .value?.roomTypes?[index].id,
                              codeNumCompleted: '0',
                              width: width,
                              roomName: bookingController.bookingDetails.value
                                      .value?.roomTypes?[index].roomType ??
                                  '',
                              roomDescription: bookingController
                                      .bookingDetails
                                      .value
                                      .value
                                      ?.roomTypes?[index]
                                      .meals
                                      ?.first ??
                                  '',
                            ),
                          ),
                        ),
                        if (bookingController
                                .bookingDetails.value.value?.type ==
                            'chalet') ...[
                          PriceWidget(
                              nights: bookingController
                                  .bookingDetails.value.value?.numberOfNight,
                              isHotel: false,
                              roomPrice: bookingController.bookingDetails.value
                                  .value?.propertyDetails?.price
                                  .toString(),
                              tax: bookingController
                                  .bookingDetails.value.value?.taxAmount
                                  .toString(),
                              discountPrice: bookingController
                                  .bookingDetails.value.value?.discountAmount,
                              totalAmount: bookingController
                                  .bookingDetails.value.value?.bookedPrice),
                          height10,
                        ],
                        // Card(
                        //   color: Colors.white,
                        //   child: ReviewHotel(
                        //     chaletCheck: 'CHALET',
                        //     hotelCityName: widget.hotelcityname.toUpperCase(),
                        //     hotelName: widget.hotelName.toUpperCase(),
                        //     image: widget.image,
                        //     morningDays: "${widget.morningdays} ${"morning".tr}",
                        //     nightDays: "${widget.nightdays} ${"nights".tr}",
                        //     width: width,
                        //     height: height,
                        //     checkIndate: dateTimeFormat(widget.checkindate,
                        //         format: 'dd MMM yyyy, EEE'),
                        //     checkoutdate:
                        //         dateTimeFormat(widget.checkout, format: 'dd MMM yyyy, EEE'),
                        //     guestInfo: "${widget.guestInfo} ${"Guest".tr}",
                        //   ),
                        // ),
                        // height10,
                        // Card(
                        //   color: kWhite,
                        //   child: Column(
                        //     children: [
                        //       ListView.separated(
                        //         separatorBuilder: (context, index) => height10,
                        //         shrinkWrap: true,
                        //         physics: const NeverScrollableScrollPhysics(),
                        //         itemCount: widget.roomDetails.length,
                        //         itemBuilder: (context, index) => RoomsQuantityWidget(
                        //             roomPrice: widget.roomPrice,
                        //             discountPrice: widget.discountPrice,
                        //             roomImage: widget.roomDetails[index].roomImages[index],
                        //             codeNumCompleted: "1",
                        //             width: width,
                        //             roomName: widget.roomDetails[index].roomTypesName,
                        //             roomDescription:
                        //                 widget.roomDetails[index].roomTypesName,
                        //             roomId: widget.roomDetails[index].roomId),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(12.0),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Text(
                        //             "Estimated Refund Amount".tr,
                        //             style: const TextStyle(
                        //                 fontSize: 20,
                        //                 fontWeight: FontWeight.w900),
                        //           ),
                        //           const Text(
                        //             "25 OMR",
                        //             style: TextStyle(
                        //                 fontSize: 20,
                        //                 fontWeight: FontWeight.bold),
                        //           )
                        //         ],
                        //       ),
                        //       height5,
                        //       Text(
                        //           "The amount will be credited to the original payment method"
                        //               .tr)
                        //     ],
                        //   ),
                        // ),
                        //! cancellation reason option-----------------------------
                        CancellationReason(controller: controller),
                      ],
                    ),
                  )
                : Center(
                    child: Text('Something went wrong'.tr),
                  ),
        bottomNavigationBar:
            bookingController.loading.value ||
                    bookingController.bookingDetails.value.value == null
                ? null
                : Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: darkRed),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    'Back'.tr,
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
                        ),
                        width15,
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (controller.selectedReason.isNotEmpty) {
                                cancelBookingApiController
                                    .checkRefundEligibility(widget.bookingId,
                                        capitalizeFirstLetter(widget.type));
                                showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Obx(() {
                                                // if (cancelBookingApiController
                                                //     .loading.value) {
                                                //   return const CircularProgressIndicator();
                                                // }
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'cancel_booking_title'.tr,
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    height20,
                                                    if (cancelBookingApiController
                                                        .loading.value)
                                                      const CircularProgressIndicator()
                                                    else if (cancelBookingApiController
                                                            .refundAmount
                                                            .value >
                                                        0) ...[
                                                      bulletPoint(
                                                          "refund_eligible_criteria"
                                                              .tr),
                                                      if (bookingController
                                                                  .bookingDetails
                                                                  .value
                                                                  .value
                                                                  ?.type ==
                                                              'chalet' &&
                                                          cancelBookingApiController
                                                                  .refundAmount
                                                                  .value >
                                                              0)
                                                        bulletPoint(
                                                            "${'You will receive'.tr} ${cancelBookingApiController.refundPercent.value}% ${'of your booking amount as a refund.'.tr}"),
                                                      bulletPoint(
                                                          "amount_to_wallet"
                                                              .tr),
                                                      bulletPoint(
                                                          "${'Estimated Refund Amount'.tr} ${cancelBookingApiController.refundAmount.value} OMR"
                                                              .tr),
                                                    ] else ...[
                                                      if (bookingController
                                                                  .bookingDetails
                                                                  .value
                                                                  .value
                                                                  ?.status ==
                                                              'pending' ||
                                                          bookingController
                                                                  .bookingDetails
                                                                  .value
                                                                  .value
                                                                  ?.status ==
                                                              'booked')
                                                        bulletPoint(
                                                            "no_refund_incomplete_payment"
                                                                .tr),
                                                      bulletPoint(
                                                          "refund_not_eligible"
                                                              .tr
                                                              .tr),
                                                      if (bookingController
                                                                  .bookingDetails
                                                                  .value
                                                                  .value
                                                                  ?.status !=
                                                              'pending' ||
                                                          bookingController
                                                                  .bookingDetails
                                                                  .value
                                                                  .value
                                                                  ?.status !=
                                                              'booked')
                                                        bulletPoint(
                                                            "no_refund".tr),
                                                    ],
                                                    height20,
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        OutlinedButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          style: OutlinedButton
                                                              .styleFrom(
                                                            shape:
                                                                const RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    8),
                                                              ),
                                                            ),
                                                          ),
                                                          child:
                                                              Text('Back'.tr),
                                                        ),
                                                        width10,
                                                        ElevatedButton(
                                                          onPressed:
                                                              cancelBookingApiController
                                                                      .loading
                                                                      .value
                                                                  ? () {}
                                                                  : () async {
                                                                      Get.back();
                                                                      if (bookingController
                                                                              .bookingDetails
                                                                              .value
                                                                              .value
                                                                              ?.type ==
                                                                          'chalet') {
                                                                        try {
                                                                          if (controller
                                                                              .selectedReason
                                                                              .value
                                                                              .isNotEmpty) {
                                                                            final data =
                                                                                BookingCancellationCHALETModel(bookingid: bookingController.bookingDetails.value.value?.bookingId.toString() ?? '', reason: controller.selectedReason.value);
                                                                            final success =
                                                                                await chaletCancellationController.cancelBookingChalet(data);
                                                                            if (success) {
                                                                              // PushNotificationApi()
                                                                              //     .cancellationBookingNotification(
                                                                              //         widget.hotelName);
                                                                              Get.offAll(const BottomNav());
                                                                            } else {
                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: const Duration(seconds: 1), content: Text(chaletCancellationController.message.value)));
                                                                            }
                                                                          } else if (controller
                                                                              .selectedReason
                                                                              .value
                                                                              .isEmpty) {
                                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                                duration: Duration(seconds: 1),
                                                                                content: Text('Select a Reason')));
                                                                          }
                                                                        } catch (e) {
                                                                          snackbar(
                                                                              "Error",
                                                                              e.toString());
                                                                        }
                                                                      } else {
                                                                        try {
                                                                          if (controller
                                                                              .selectedReason
                                                                              .value
                                                                              .isNotEmpty) {
                                                                            final data = BookingCancellationModel(
                                                                                bookingid: bookingController.bookingDetails.value.value?.bookingId ?? '',
                                                                                hotelId: int.parse(bookingController.bookingDetails.value.value?.propertyDetails?.id.toString() ?? ''),
                                                                                reason: controller.selectedReason.value);
                                                                            final success =
                                                                                await cancelBookingApiController.cancelBooking(data);
                                                                            if (success) {
                                                                              // PushNotificationApi()
                                                                              //     .cancellationBookingNotification(
                                                                              //         widget.hotelName);
                                                                              Get.offAll(const BottomNav());
                                                                            } else {
                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: const Duration(seconds: 1), content: Text(cancelBookingApiController.message.value)));
                                                                            }
                                                                          } else if (controller
                                                                              .selectedReason
                                                                              .value
                                                                              .isEmpty) {
                                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                                duration: Duration(seconds: 1),
                                                                                content: Text('Select a Reason')));
                                                                          } else {
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                duration: const Duration(seconds: 1),
                                                                                content: Text('Pls select Rooms you want to cancel'.tr)));
                                                                          }
                                                                        } catch (e) {
                                                                          snackbar(
                                                                              "Error".tr,
                                                                              'something went wrong'.tr);
                                                                        }
                                                                      }
                                                                    },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                darkRed,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            'confirm'.tr,
                                                            style:
                                                                const TextStyle(
                                                                    color:
                                                                        kWhite),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                );
                                              }),
                                            ),
                                          ),
                                        ));

                                // Get.defaultDialog(
                                //   radius: 20,

                                //   // textCancel: "Back".tr,
                                //   // textConfirm: "Confirm".tr,
                                //   titlePadding: const EdgeInsets.only(top: 20),

                                //   titleStyle: const TextStyle(
                                //       fontSize: 18, fontWeight: FontWeight.bold),
                                //   //  contentPadding: const EdgeInsets.only(top: 20),
                                //   onWillPop: () => Future.value(false),
                                //   barrierDismissible: false,

                                //   title:
                                //       "Are you sure you want to cancel your booking?",
                                //   // "${'cancel_booking'.tr} ${bookingController.bookingDetails.value.value?.propertyDetails?.name?.toUpperCase()}",
                                //   buttonColor: darkRed,
                                //   content: Padding(
                                //     padding: const EdgeInsets.all(8.0),
                                //     child: Obx(() {
                                //       if (cancelBookingApiController
                                //           .loading.value) {
                                //         return const CircularProgressIndicator();
                                //       }
                                //       return Column(
                                //         children: [
                                //           if (cancelBookingApiController
                                //                   .refundAmount.value >
                                //               0) ...[
                                //             bulletPoint(
                                //                 "You are eligible for a refund only if it meets the cancellation policy criteria. "
                                //                     .tr),
                                //             if (bookingController.bookingDetails
                                //                         .value.value?.type ==
                                //                     'chalet' &&
                                //                 cancelBookingApiController
                                //                         .refundAmount.value >
                                //                     0)
                                //               bulletPoint(
                                //                   "You will receive ${cancelBookingApiController.refundPercent.value}% of your booking amount as a refund. "),
                                //             bulletPoint(
                                //                 "The refunded amount will be credited to your app wallet."),
                                //             bulletPoint(
                                //                 "Estimated refund amount ${cancelBookingApiController.refundAmount.value} OMR"),
                                //           ] else ...[
                                //             bulletPoint(
                                //                 "You are not eligible for a refund as per the cancellation policy."),
                                //             bulletPoint(
                                //                 "No refund will be provided for this cancellation."),
                                //           ]
                                //         ],
                                //       );
                                //     }),
                                //   ),
                                //   actions: [
                                //     OutlinedButton(
                                //       onPressed: () {
                                //         Get.back();
                                //       },
                                //       style: OutlinedButton.styleFrom(
                                //         shape: const RoundedRectangleBorder(
                                //           borderRadius: BorderRadius.all(
                                //             Radius.circular(8),
                                //           ),
                                //         ),
                                //       ),
                                //       child: const Text('Back'),
                                //     ),
                                //     width10,
                                //     ElevatedButton(
                                //       onPressed: () async {
                                //         Get.back();
                                //         if (bookingController
                                //                 .bookingDetails.value.value?.type ==
                                //             'chalet') {
                                //           try {
                                //             if (controller
                                //                 .selectedReason.value.isNotEmpty) {
                                //               final data =
                                //                   BookingCancellationCHALETModel(
                                //                       bookingid: bookingController
                                //                               .bookingDetails
                                //                               .value
                                //                               .value
                                //                               ?.bookingId
                                //                               .toString() ??
                                //                           '',
                                //                       reason: controller
                                //                           .selectedReason.value);
                                //               final success =
                                //                   await chaletCancellationController
                                //                       .cancelBookingChalet(data);
                                //               if (success) {
                                //                 // PushNotificationApi()
                                //                 //     .cancellationBookingNotification(
                                //                 //         widget.hotelName);
                                //                 Get.offAll(const BottomNav());
                                //               } else {
                                //                 ScaffoldMessenger.of(context)
                                //                     .showSnackBar(SnackBar(
                                //                         duration: const Duration(
                                //                             seconds: 1),
                                //                         content: Text(
                                //                             chaletCancellationController
                                //                                 .message.value)));
                                //               }
                                //             } else if (controller
                                //                 .selectedReason.value.isEmpty) {
                                //               ScaffoldMessenger.of(context)
                                //                   .showSnackBar(const SnackBar(
                                //                       duration:
                                //                           Duration(seconds: 1),
                                //                       content:
                                //                           Text('Select a Reason')));
                                //             }
                                //           } catch (e) {
                                //             snackbar("Error", e.toString());
                                //           }
                                //         } else {
                                //           try {
                                //             if (controller
                                //                 .selectedReason.value.isNotEmpty) {
                                //               final data = BookingCancellationModel(
                                //                   bookingid: bookingController
                                //                           .bookingDetails
                                //                           .value
                                //                           .value
                                //                           ?.bookingId ??
                                //                       '',
                                //                   hotelId: int.parse(
                                //                       bookingController
                                //                               .bookingDetails
                                //                               .value
                                //                               .value
                                //                               ?.propertyDetails
                                //                               ?.id
                                //                               .toString() ??
                                //                           ''),
                                //                   reason: controller
                                //                       .selectedReason.value);
                                //               final success =
                                //                   await cancelBookingApiController
                                //                       .cancelBooking(data);
                                //               if (success) {
                                //                 // PushNotificationApi()
                                //                 //     .cancellationBookingNotification(
                                //                 //         widget.hotelName);
                                //                 Get.offAll(const BottomNav());
                                //               } else {
                                //                 ScaffoldMessenger.of(context)
                                //                     .showSnackBar(SnackBar(
                                //                         duration: const Duration(
                                //                             seconds: 1),
                                //                         content: Text(
                                //                             cancelBookingApiController
                                //                                 .message.value)));
                                //               }
                                //             } else if (controller
                                //                 .selectedReason.value.isEmpty) {
                                //               ScaffoldMessenger.of(context)
                                //                   .showSnackBar(const SnackBar(
                                //                       duration:
                                //                           Duration(seconds: 1),
                                //                       content:
                                //                           Text('Select a Reason')));
                                //             } else {
                                //               ScaffoldMessenger.of(context)
                                //                   .showSnackBar(SnackBar(
                                //                       duration: const Duration(
                                //                           seconds: 1),
                                //                       content: Text(
                                //                           'Pls select Rooms you want to cancel'
                                //                               .tr)));
                                //             }
                                //           } catch (e) {
                                //             snackbar("Error", e.toString());
                                //           }
                                //         }
                                //       },
                                //       style: ElevatedButton.styleFrom(
                                //         backgroundColor: darkRed,
                                //         shape: RoundedRectangleBorder(
                                //           borderRadius: BorderRadius.circular(8),
                                //         ),
                                //       ),
                                //       child: const Text(
                                //         'Confirm',
                                //         style: TextStyle(color: kWhite),
                                //       ),
                                //     )
                                //   ],
                                //   // onCancel: () => Get.back(),
                                //   // onConfirm: () async {
                                //   //   Get.back();

                                //   //   String bookingID = '';
                                //   //   // var booking = bookingController.mergedUpcomingData[0];

                                //   //   // if (booking is ChaletBookingUpcoming) {
                                //   //   //   bookingID = booking.bookingId.toString();
                                //   //   // }
                                //   //   if (bookingController
                                //   //           .bookingDetails.value.value?.type ==
                                //   //       'chalet') {
                                //   //     try {
                                //   //       if (controller
                                //   //           .selectedReason.value.isNotEmpty) {
                                //   //         final data =
                                //   //             BookingCancellationCHALETModel(
                                //   //                 bookingid: bookingController
                                //   //                         .bookingDetails
                                //   //                         .value
                                //   //                         .value
                                //   //                         ?.bookingId
                                //   //                         .toString() ??
                                //   //                     '',
                                //   //                 reason: controller
                                //   //                     .selectedReason.value);
                                //   //         final success =
                                //   //             await chaletCancellationController
                                //   //                 .cancelBookingChalet(data);
                                //   //         if (success) {
                                //   //           // PushNotificationApi()
                                //   //           //     .cancellationBookingNotification(
                                //   //           //         widget.hotelName);
                                //   //           Get.offAll(const BottomNav());
                                //   //         } else {
                                //   //           ScaffoldMessenger.of(context)
                                //   //               .showSnackBar(SnackBar(
                                //   //                   duration:
                                //   //                       const Duration(seconds: 1),
                                //   //                   content: Text(
                                //   //                       chaletCancellationController
                                //   //                           .message.value)));
                                //   //         }
                                //   //       } else if (controller
                                //   //           .selectedReason.value.isEmpty) {
                                //   //         ScaffoldMessenger.of(context)
                                //   //             .showSnackBar(const SnackBar(
                                //   //                 duration: Duration(seconds: 1),
                                //   //                 content:
                                //   //                     Text('Select a Reason')));
                                //   //       }
                                //   //     } catch (e) {
                                //   //       snackbar("Error", e.toString());
                                //   //     }
                                //   //   } else {
                                //   //     try {
                                //   //       if (controller
                                //   //           .selectedReason.value.isNotEmpty) {
                                //   //         final data = BookingCancellationModel(
                                //   //             bookingid: bookingController
                                //   //                     .bookingDetails
                                //   //                     .value
                                //   //                     .value
                                //   //                     ?.bookingId ??
                                //   //                 '',
                                //   //             hotelId: int.parse(bookingController
                                //   //                     .bookingDetails
                                //   //                     .value
                                //   //                     .value
                                //   //                     ?.propertyDetails
                                //   //                     ?.id
                                //   //                     .toString() ??
                                //   //                 ''),
                                //   //             reason:
                                //   //                 controller.selectedReason.value);
                                //   //         final success =
                                //   //             await cancelBookingApiController
                                //   //                 .cancelBooking(data);
                                //   //         if (success) {
                                //   //           // PushNotificationApi()
                                //   //           //     .cancellationBookingNotification(
                                //   //           //         widget.hotelName);
                                //   //           Get.offAll(const BottomNav());
                                //   //         } else {
                                //   //           ScaffoldMessenger.of(context)
                                //   //               .showSnackBar(SnackBar(
                                //   //                   duration:
                                //   //                       const Duration(seconds: 1),
                                //   //                   content: Text(
                                //   //                       cancelBookingApiController
                                //   //                           .message.value)));
                                //   //         }
                                //   //       } else if (controller
                                //   //           .selectedReason.value.isEmpty) {
                                //   //         ScaffoldMessenger.of(context)
                                //   //             .showSnackBar(const SnackBar(
                                //   //                 duration: Duration(seconds: 1),
                                //   //                 content:
                                //   //                     Text('Select a Reason')));
                                //   //       } else {
                                //   //         ScaffoldMessenger.of(context)
                                //   //             .showSnackBar(SnackBar(
                                //   //                 duration:
                                //   //                     const Duration(seconds: 1),
                                //   //                 content: Text(
                                //   //                     'Pls select Rooms you want to cancel'
                                //   //                         .tr)));
                                //   //       }
                                //   //     } catch (e) {
                                //   //       snackbar("Error", e.toString());
                                //   //     }
                                //   //   }
                                //   // },
                                // );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        duration: const Duration(seconds: 1),
                                        content: Text('Select a Reason'.tr)));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: darkRed,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Obx(
                                () => cancelBookingApiController.loading.value
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          backgroundColor: kWhite,
                                        ))
                                    : chaletCancellationController.loading.value
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              backgroundColor: kWhite,
                                            ))
                                        : Text(
                                            'Cancel'.tr,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      );
    });
  }

  Row bulletPoint(String message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('•  '),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: kGrey),
            // textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  getRoomPrice() {
    double price = 0;
    price =
        (bookingController.bookingDetails.value.value?.roomTypes?.first.price ??
                0) *
            (bookingController.bookingDetails.value.value?.numberOfRooms ?? 0);
    // bookingController.bookingDetails.value.value?.roomTypes
    //     ?.forEach((e) => price += e.price!);
    return price;
  }
}

class CancellationController extends GetxController {
  var selectedReason = ''.obs;

  void updateReason(String reason) {
    selectedReason.value = reason;
  }
}
