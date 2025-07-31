import 'package:e_concierge_tourism/common/bottom_nav_buttom_property_details_page/bottom_buttom_hoteldetails_page.dart';
import 'package:e_concierge_tourism/common/capitalized_word/capitialize_word.dart';
import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import 'package:e_concierge_tourism/common/snackbar/snackbar.dart';
import 'package:e_concierge_tourism/common/ui_property_details_page_widget/propert_rules_details.dart';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/controller/api/upcoming_section/booking_detail_controller.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/review_page_notf.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/upcoming_section_hotel/completed.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/upcoming_section_hotel/rooms_details.dart';
import 'package:e_concierge_tourism/controller/service/socket_service/socket_service.dart';
import 'package:e_concierge_tourism/getx/date_picker_controller.dart';
import 'package:e_concierge_tourism/utils/count_down_widget.dart';
import 'package:e_concierge_tourism/utils/date_time.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:e_concierge_tourism/view/chalets_booking/search_page/search_chalets.dart';
import 'package:e_concierge_tourism/view/hotel_booking/search_hotels/search_hotels.dart';
import 'package:e_concierge_tourism/view/hotel_booking/successs_page.dart/success_booking.dart';
import 'package:e_concierge_tourism/view/my_bookings/completed/rating_widget.dart';
import 'package:e_concierge_tourism/view/payment/controller/payment_controller.dart';
import 'package:e_concierge_tourism/view/payment/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../controller/api/upcoming_section/success_details.dart';
import '../../hotel_booking/reviewbooking/widgets/review_hotel.dart';
import '../../hotel_booking/reviewbooking/widgets/room_quantity_widget.dart';

class ViewMoreDetailsPage extends StatefulWidget {
  final String propertyId;
  final String type;
  const ViewMoreDetailsPage({
    super.key,
    required this.propertyId,
    required this.type,
  });

  @override
  ViewMoreDetailsPageState createState() => ViewMoreDetailsPageState();
}

class ViewMoreDetailsPageState extends State<ViewMoreDetailsPage> {
  late BookingDetailApiController bookingController;
  final PaymentController paymentController = Get.put(PaymentController());
  final DatePickerController datePickercontroller = Get.find();
  final bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // SocketService.listenSocket((bookingId, status) {});
    Get.put(RoomsControllerCheckBox());
    bookingController = Get.put(BookingDetailApiController());
    bookingController.getBookingDetails(widget.propertyId, widget.type);

    // for (var room in widget.roomDetails) {
    //   Get.find<RoomsControllerCheckBox>().initializeRoomState(room.roomId);
    // }
  }

  @override
  void dispose() {
    // SocketService.closeSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Obx(() {
      final bookingDetail = bookingController.bookingDetails.value.value;
      return Scaffold(
        appBar: MyAppBar(
            title: bookingController
                    .bookingDetails.value.value?.propertyDetails?.name
                    ?.toUpperCase() ??
                ''),
        body: bookingController.loading.value
            ? const Center(child: CircularProgressIndicator())
            : bookingController.bookingDetails.value.value != null
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView(
                      children: [
                        showBookingStatusCard(
                            bookingDetail?.status ?? '',
                            bookingDetail?.availabilityTime,
                            bookingDetail?.paymentExpiryTime,
                            bookingDetail?.paymentCategory),
                        height10,
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.white,
                          child: ReviewHotel(
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
                                "${bookingController.bookingDetails.value.value?.numberOfMorning} ${"days".tr}",
                            nightDays:
                                "${bookingController.bookingDetails.value.value?.numberOfNight} ${"nights".tr}",
                            width: width,
                            height: height,
                            hotelRating: bookingController.bookingDetails.value
                                    .value?.propertyDetails?.hotelRating ??
                                '',
                            propertyType: bookingController.bookingDetails.value
                                .value?.propertyDetails?.propertyType,
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
                                "${bookingController.bookingDetails.value.value?.numberOfRooms} ${'room'.tr} & ${bookingController.bookingDetails.value.value?.guestCount} ${'Members'.tr}"
                                    .tr,
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
                              itemBuilder: (context, index) {
                                return RoomsQuantityWidget(
                                  numberofRooms: bookingController
                                          .bookingDetails
                                          .value
                                          .value
                                          ?.numberOfRooms ??
                                      0,
                                  nights: bookingController.bookingDetails.value
                                      .value?.numberOfNight,
                                  index: index,
                                  length: bookingController.bookingDetails.value
                                          .value?.roomTypes?.length ??
                                      0,
                                  check: "VIEW_MORE_DETAILS",
                                  discountPrice: bookingController
                                      .bookingDetails
                                      .value
                                      .value
                                      ?.discountAmount
                                      .toString(),
                                  roomPrice: getRoomPrice().toString(),
                                  tax: bookingController
                                      .bookingDetails.value.value?.taxAmount
                                      .toString(),
                                  mealPrice: bookingController
                                      .bookingDetails.value.value?.mealPrice,
                                  mealTax: bookingController
                                      .bookingDetails.value.value?.mealTax,
                                  totalAmount: bookingController.bookingDetails
                                          .value.value?.bookedPrice
                                          .toString() ??
                                      '',
                                  roomImage: bookingController
                                          .bookingDetails
                                          .value
                                          .value
                                          ?.roomTypes?[index]
                                          .image ??
                                      '',
                                  roomId: bookingController.bookingDetails.value
                                      .value?.roomTypes?[index].id,
                                  codeNumCompleted: '0',
                                  width: width,
                                  roomName: bookingController
                                          .bookingDetails
                                          .value
                                          .value
                                          ?.roomTypes?[index]
                                          .roomType ??
                                      '',
                                  roomDescription: getRoomDescription(index),
                                );
                              }),
                        ),
                        height10,
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
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final policies = bookingController.bookingDetails
                                .value.value?.propertyDetails?.policies;
                            return policies != null && policies.isNotEmpty
                                ? SizedBox(
                                    width: double.infinity,
                                    child: Card(
                                      color: kWhite,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      elevation: 4.0,
                                      child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Property Rules & Info'.tr,
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),
                                              if (policies.isNotEmpty) ...[
                                                for (var entry in policies
                                                    .entries
                                                    .take(1)) ...[
                                                  Text(
                                                    entry.key,
                                                    style: const TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5.0),
                                                  ...entry.value
                                                      .take(1)
                                                      .map((data) => Text(
                                                            "• $data",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14.0),
                                                          )),
                                                  if (entry
                                                      .value.isNotEmpty) ...[
                                                    const SizedBox(
                                                        height: 10.0),
                                                    InkWell(
                                                      onTap: () {
                                                        Get.to(
                                                            PropertyRulesDetails(
                                                          propertyPolicies: '',
                                                          policies: policies,
                                                        ));
                                                      },
                                                      child: Text(
                                                        'View All'.tr,
                                                        style: const TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  const SizedBox(height: 15.0),
                                                ],
                                              ] else ...[
                                                Text(
                                                  'No property rules information available.'
                                                      .tr,
                                                  style: const TextStyle(
                                                      fontSize: 14.0),
                                                ),
                                              ],
                                            ],
                                          )),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                        // //  height10,
                        if (bookingController
                                .bookingDetails.value.value?.status ==
                            'completed')
                          Rating(
                            check: widget.type,
                            bookingID: bookingController
                                    .bookingDetails.value.value?.bookingId ??
                                '',
                            propertyID: bookingController.bookingDetails.value
                                    .value?.propertyDetails?.id
                                    .toString() ??
                                '',
                            hotelId: bookingController.bookingDetails.value
                                    .value?.propertyDetails?.id
                                    .toString() ??
                                '',
                            userRating: bookingController
                                .bookingDetails.value.value?.userRatingReview,
                          ),

                        // const Card(
                        //   color: kWhite,
                        //   child: Padding(
                        //     padding: EdgeInsets.all(8.0),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Padding(
                        //           padding: EdgeInsets.only(right: 10, left: 10),
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //             children: [Text("First name"), Text("Sufad")],
                        //           ),
                        //         ),
                        //         height5,
                        //         Padding(
                        //           padding: EdgeInsets.only(right: 10, left: 10),
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //             children: [Text("Last name"), Text("Zan")],
                        //           ),
                        //         ),
                        //         height5,
                        //         Padding(
                        //           padding: EdgeInsets.only(right: 10, left: 10),
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               Text("Email address"),
                        //               Text("Sufad@gmail.com")
                        //             ],
                        //           ),
                        //         ),
                        //         height10,
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  )
                : Center(
                    child: Text('Something went wrong'.tr),
                  ),
        bottomNavigationBar:
            bookingController.bookingDetails.value.value?.status == 'booked' &&
                    !bookingController.loading.value
                ? BottomButtomHotelDetailsPage(
                    buttonname: 'pay now'.tr,
                    shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
                    price:
                        "${bookingController.bookingDetails.value.value?.bookedPrice ?? ''} ${"OMR".tr}",
                    ontap: () {
                      goToPaymentScreen();
                    },
                  )
                : null,
      );
    });
  }

  getRoomDescription(index) {
    if (bookingController
            .bookingDetails.value.value?.roomTypes?[index].meals?.isNotEmpty ??
        false) {
      return bookingController
          .bookingDetails.value.value?.roomTypes?[index].meals?.first;
    }
    return 'No meals';
  }

  goToSearch(String type) {
    if (type == 'hotel') {
      Get.to(
        () => SearchHotel(
          index: 0,
        ),
      );
    } else {
      Get.to(
        () => ChaletSearchPage(),
      );
    }
  }

  goToPaymentScreen() {
    final bookingDetail = bookingController.bookingDetails.value.value;
    final price = bookingDetail?.bookedPrice.toString() ?? '';
    final propertyImage = bookingDetail?.propertyDetails?.image;
    final propertyname = bookingDetail?.propertyDetails?.name;
    final morningDaysNumber = bookingDetail?.numberOfMorning ?? 0;
    final nightdaysNumber = bookingDetail?.numberOfNight ?? 0;
    final checkinDate = bookingDetail?.checkin ?? DateTime.now();
    final checkoutDate = bookingDetail?.checkout ?? DateTime.now();
    final roomCount = bookingDetail?.numberOfRooms ?? 0;
    Get.to(
      () => PaymentSelectionScreen(
        id: bookingDetail?.propertyDetails?.id ?? 0,
        propertyType: widget.type.toLowerCase(),
        pay: (payMethod) async {
          print('kell $payMethod');
          // Get.back();
          // Set loading to true and show the dialog before starting the async operation
          // paymentController.loading.value = true;
          Get.defaultDialog(
            barrierDismissible: false,
            title: "",
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: darkRed,
                ),
                const SizedBox(height: 15),
                Text(
                  "loading".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            backgroundColor: kWhite,
            radius: 10,
          );
          final success = await paymentController.pay(
              widget.propertyId,
              payMethod,
              price,
              capitalizeFirstLetter(widget.type),
              bookingDetail?.guestDetails);
          Navigator.of(context).pop();
          if (success != null) {
            if ("Online" == payMethod) {
              Get.off(() => PaymentWebView(
                    onRefresh: () {
                      navigateToSucessScreen();
                    },
                    // controller: controller,
                    // loading: _isLoading,
                    paymentUrl: success.paymentUrl ?? ' ',
                  ));
            } else {
              bookingController.bookingDetails.value.value?.status =
                  'confirmed';
              setState(() {});
              Get.off(
                () => SuccessBooking(
                  roomTypes: bookingDetail?.roomTypes,
                  bookingdetails: success,
                  hotelImage: propertyImage ?? '',
                  hotelName: propertyname ?? '',
                  totalPrice: "$price OMR",
                  morningDays: morningDaysNumber <= 1
                      ? '$morningDaysNumber  ${'day'.tr}'
                      : '$morningDaysNumber ${'days'.tr}',
                  nightDays: nightdaysNumber <= 1
                      ? '$nightdaysNumber  ${'night'.tr}'
                      : '$nightdaysNumber ${'nights'.tr}',
                  checkinTime:
                      datePickercontroller.getFormattedDate(checkinDate),
                  checkoutTime:
                      datePickercontroller.getFormattedDate(checkoutDate),
                  roomsAndmembers:
                      "$roomCount ${"room".tr}, ${success.adults} ${"adult".tr}${success.children >= 0 ? ', ${success.children} ${"children".tr}' : ''}",
                ),
              );
            }
          } else {
            snackbar("Payment Failed".tr, paymentController.message.value);
          }
        },
        totalAmount: price,
      ),
    );
  }

  navigateToSucessScreen() {
    bookingController.bookingDetails.value.value?.status = 'confirmed';
    setState(() {});
    final bookingDetail = bookingController.bookingDetails.value.value;
    final price = bookingDetail?.bookedPrice.toString() ?? '';
    final propertyImage = bookingDetail?.propertyDetails?.image;
    final propertyname = bookingDetail?.propertyDetails?.name;
    final morningDaysNumber = bookingDetail?.numberOfMorning ?? 0;
    final nightdaysNumber = bookingDetail?.numberOfNight ?? 0;
    final checkinDate = bookingDetail?.checkin ?? DateTime.now();
    final checkoutDate = bookingDetail?.checkout ?? DateTime.now();
    final roomCount = bookingDetail?.numberOfRooms ?? 0;
    final success = BookingData(
      id: 0,
      qrcode: bookingDetail?.qrCode,
      adults: bookingDetail?.guestCount ?? 0,
      children: bookingDetail?.guestCount ?? 0,
      hotelName: propertyname ?? '',
      bookingNumber: bookingDetail?.bookingId,
      firstName: bookingDetail?.guestDetails?.firstName ?? '',
      secondName: bookingDetail?.guestDetails?.lastName ?? '',
      checkinDate: checkinDate,
      checkoutDate: checkoutDate,
      email: bookingDetail?.guestDetails?.email ?? '',
      guests: bookingDetail?.guestCount,
      contactNumber: bookingDetail?.guestDetails?.mobileNumber,
    );
    Get.to(
      () => SuccessBooking(
        roomTypes: bookingDetail?.roomTypes,
        bookingdetails: success,
        hotelImage: propertyImage ?? '',
        hotelName: propertyname ?? '',
        totalPrice: "$price OMR",
        morningDays: morningDaysNumber <= 1
            ? '$morningDaysNumber  ${'day'.tr}'
            : '$morningDaysNumber ${'days'.tr}',
        nightDays: nightdaysNumber <= 1
            ? '$nightdaysNumber  ${'night'.tr}'
            : '$nightdaysNumber ${'nights'.tr}',
        checkinTime: datePickercontroller.getFormattedDate(checkinDate),
        checkoutTime: datePickercontroller.getFormattedDate(checkoutDate),
        roomsAndmembers:
            "$roomCount ${"room".tr}, ${success.adults} ${"adult".tr}${success.children >= 0 ? ', ${success.children} ${"children".tr}' : ''}",
      ),
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

  Widget showBookingStatusCard(String status, DateTime? availabilityWT,
      DateTime? paymentET, String? paymentCategory) {
    switch (status) {
      case 'confirmed':
        return BookingStatusCard(
          status: 'Completed',
          title: "confirmed_booking_title".tr,
          message: "confirmed_booking_message".tr,
          children: [
            const Spacer(),
            SizedBox(
              height: 30,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    backgroundColor: kLightGreen,
                    foregroundColor: kWhite),
                child: paymentCategory == 'Cash'
                    ? Text('pay_at_checkin'.tr)
                    : Text('Paid'.tr),
              ),
            ),
          ],
        );
      case 'booked':
        return BookingStatusCard(
          status: 'Approved',
          title: 'vendor_approved_title'.tr,
          message: 'vendor_approved_message'.tr,
          children: [
            SizedBox(
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  bookingController.getBookingDetails(
                      widget.propertyId, widget.type);
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    backgroundColor: const Color(0xFF85080C),
                    foregroundColor: kWhite),
                child: Text('Refresh'.tr),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  goToPaymentScreen();
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    backgroundColor: kLightGreen,
                    foregroundColor: kWhite),
                child: Text('pay now'.tr),
              ),
            ),
            width10,
            SizedBox(
              height: 30,
              child: CountDownButton(
                time: paymentET ?? DateTime.now(),
                onTap: () {},
              ),
            ),
          ],
        );
      case 'rejected':
        return BookingStatusCard(
          title: 'rejected_title'.tr,
          status: 'Rejected',
          message: 'rejected_message'.tr,
          children: [
            const Spacer(),
            SizedBox(
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  goToSearch(
                      bookingController.bookingDetails.value.value?.type ?? '');
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    backgroundColor: kLightGreen,
                    foregroundColor: kWhite),
                child: Text('find alternative'.tr),
              ),
            ),
          ],
        );
      case 'expired':
        return BookingStatusCard(
          status: 'Expired',
          title: 'booking_expired_title'.tr,
          message: 'booking_expired_message'.tr,
          children: [
            SizedBox(
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  openMailApp('1929way@gmail.com');
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    backgroundColor: const Color(0xFF85080C),
                    foregroundColor: kWhite),
                child: Text('need_assistance'.tr),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  goToSearch(
                      bookingController.bookingDetails.value.value?.type ?? '');
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    backgroundColor: kLightGreen,
                    foregroundColor: kWhite),
                child: Text('find alternative'.tr),
              ),
            ),
          ],
        );
      case 'pending':
        return BookingStatusCard(
          status: 'pending',
          title: "check_availability".tr,
          message: "check_availability_message".tr,
          children: [
            SizedBox(
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  bookingController.getBookingDetails(
                      widget.propertyId, widget.type);
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    backgroundColor: const Color(0xFF85080C),
                    foregroundColor: kWhite),
                child: Text('Refresh'.tr),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 30,
              child: CountDownButton(
                time: availabilityWT ?? DateTime.now(),
                onTap: () {},
              ),
            ),
          ],
        );
      case 'cancelled':
        return BookingStatusCard(
          status: 'Cancelled',
          title: "cancelled_booking_title".tr,
          message: "cancelled_booking_message".tr,
          children: const [],
        );
      case 'completed':
        return BookingStatusCard(
          status: 'Completed',
          title: "booking_completed_title".tr,
          message: "booking_completed_message".tr,
          children: const [],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class BookingStatusCard extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget> children;
  final String status;
  const BookingStatusCard({
    super.key,
    required this.title,
    required this.message,
    required this.children,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: kWhite,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: status == 'Rejected' ||
                        status == 'Cancelled' ||
                        status == 'Expired'
                    ? kRed
                    : kGreen,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            height10,
            Text(message),
            height20,
            Row(children: children)
          ],
        ),
      ),
    );
  }
}

class PaymentWebView extends StatefulWidget {
  const PaymentWebView(
      {super.key, required this.paymentUrl, r, required this.onRefresh});
  final String paymentUrl;
  final Function onRefresh;

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  bool _isLoading = true;
  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            if (url.startsWith(
                    'https://unifiedpg.nbo.om/OLTP/paymentpage.htm?PaymentID') ||
                url.startsWith(
                    'https://unifiedpg.nbo.om/OLTPSTG/paymentpage.htm?')) {
              setState(() {
                _isLoading = true;
                ('loading value $_isLoading');
              });
            }
          },
          onPageFinished: (String url) {
            print('finished page ${url}');
            print(url.startsWith(
                    'https://unifiedpg.nbo.om/OLT/paymentpage.htm?PaymentID') ||
                url.startsWith(
                    'https://unifiedpg.nbo.om/OLTPSTG/paymentpage.htm?'));
            if (url.startsWith(
                    'https://unifiedpg.nbo.om/OLTP/paymentpage.htm?PaymentID') ||
                url.startsWith(
                    'https://unifiedpg.nbo.om/OLTPSTG/paymentpage.htm?')) {
              setState(() {
                _isLoading = false;
                ('loading value $_isLoading');
              });
            }
          },
          onUrlChange: (UrlChange url) async {
            print('urll change ${url.url}');
            if (url.url?.startsWith(
                    '$baseUrl/common/payment-status?status=success') ??
                false) {
              await Future.delayed(
                  const Duration(seconds: 3), () => Get.back());
              // navigateToSucessScreen();
              widget.onRefresh();
            } else if (url.url?.startsWith(
                    '$baseUrl/common/payment-status?status=failed') ??
                false) {
              await Future.delayed(
                  const Duration(seconds: 3), () => Get.back());
            } else if (url.url?.startsWith(
                    '$baseUrl/common/wallet-payment-status?status=success') ??
                false) {
              await Future.delayed(const Duration(seconds: 3), () {
                Get.back();
                widget.onRefresh();
              });
            } else if (url.url?.startsWith(
                    '$baseUrl/common/wallet-payment-status?status=failed') ??
                false) {
              await Future.delayed(
                  const Duration(seconds: 3), () => Get.back());
              // snackbar('Failed'.tr, 'Payment failed');
            }
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
