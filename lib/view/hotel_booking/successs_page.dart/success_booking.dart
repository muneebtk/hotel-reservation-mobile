import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/review_page_notf.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/upcoming_section_hotel/booking_detail_response.dart';
import 'package:e_concierge_tourism/getx/room_controller.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:e_concierge_tourism/view/bottom_nav.dart/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/styles/colors.dart';
import '../../../constant/styles/sizedbox.dart';
import '../../../controller/service/push_notification/push_notification_api.dart';
import '../../../common/pdf/pdf_flutter.dart';

class SuccessBooking extends StatelessWidget {
  final String hotelName;
  final String morningDays;
  final String nightDays;
  final String checkinTime;
  final String checkoutTime;
  final String? roomsAndmembers;
  final List<RoomType>? roomTypes;
  // final String firstName;
  // final String lastname;
  // final String email;
  final String? selectedOption;
  // final String mobileNumber;
  final String totalPrice;
  final String hotelImage;
  final BookingData? bookingdetails;
  const SuccessBooking(
      {super.key,
      required this.morningDays,
      required this.nightDays,
      required this.checkinTime,
      required this.checkoutTime,
      this.roomsAndmembers,
      // required this.firstName,
      // required this.lastname,
      // required this.email,
      this.selectedOption,
      this.roomTypes,
      // required this.mobileNumber,
      required this.totalPrice,
      required this.hotelName,
      required this.hotelImage,
      this.bookingdetails});

  @override
  Widget build(BuildContext context) {
    // notfShowing("$hotelName $checkinTime-$checkoutTime", firstName);
    var size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return Scaffold(
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: constraints.maxHeight / 3.5,
                    color: const Color(0xFF4CAF50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.network(
                            "https://cdn2.iconfinder.com/data/icons/weby-flat-vol-1/512/1_Approved-check-checkbox-confirm-green-success-tick-512.png",
                            fit: BoxFit.cover,
                            height: constraints.maxHeight / 7,
                          ),
                        ),
                        Text(
                          "booking_confirmed".tr,
                          style: textBoldwhite,
                        )
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  top: constraints.maxHeight / 4.5,
                  child: Padding(
                    padding: EdgeInsets.all(constraints.maxWidth * 0.05),
                    child: SingleChildScrollView(
                      child: Card(
                        color: kWhite,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 195, 215, 197),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                width: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      constraints.maxWidth * 0.025),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hotelName,
                                        style: textBoldblack,
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: List.generate(
                                            roomTypes?.length ?? 0,
                                            (index) => Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Text(
                                                  "${roomTypes?[index].roomType}${index != roomTypes!.length - 1 ? "," : ""}"
                                                      .toUpperCase()),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              height10,
                              Row(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("duration".tr),
                                          Text(
                                            '$nightDays ${"and".tr} $morningDays',
                                            style: TextStyle(
                                              fontSize: width * 0.05,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // SizedBox(height: height * 0.01),
                                          // Text('Room_members'.tr,
                                          //     style: TextStyle(
                                          //         fontSize: width * 0.03)),
                                          // Text(roomsAndmembers.toString(),
                                          //     style: TextStyle(
                                          //         fontSize: width * 0.03)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                      child: bookingdetails?.qrcode != null
                                          ? Image.network(
                                              bookingdetails?.qrcode ?? '',
                                              fit: BoxFit.cover,
                                            )
                                          : const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  )
                                ],
                              ),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "checkin".tr,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                        Text(checkinTime)
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "checkout".tr,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                        Text(checkoutTime),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const Divider(),
                              Card(
                                margin: const EdgeInsets.all(8.0),
                                color: const Color.fromARGB(255, 252, 228, 234),
                                elevation: 0,
                                child: ListTile(
                                  title: Text(
                                    "booking_code".tr,
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                  ),
                                  subtitle:
                                      Text(bookingdetails?.bookingNumber ?? ''),
                                  trailing: IconButton(
                                      onPressed: () {
                                        copyToClipBoard(
                                            bookingdetails?.bookingNumber);
                                      },
                                      icon: const Icon(Icons.file_copy_sharp)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "contact_info".tr,
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "full_name".tr,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${bookingdetails?.firstName} ${bookingdetails?.secondName}",
                                            style: textBoldblack,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Phone".tr,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            bookingdetails?.contactNumber ?? '',
                                            style: textBoldblack,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "email".tr,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            bookingdetails?.email ?? '',
                                            style: textBoldblack,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${"total_amount_to_be_paid".tr}:",
                                            style: textBoldblack.copyWith(
                                                fontSize: 15),
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            totalPrice,
                                            style: textBoldblack.copyWith(
                                                fontSize: 15),
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
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
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.offAll(const BottomNav());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: darkRed),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          width25,
                          const Icon(
                            Icons.home,
                            color: darkRed,
                          ),
                          width10,
                          Expanded(
                            child: Text(
                              "home".tr,
                              style: const TextStyle(
                                  overflow: TextOverflow.visible,
                                  color: darkRed,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              //Pdf section--

              width10,
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final bookingDetails = BookingDetails(
                      roomsAndmembers: roomsAndmembers.toString(),
                      hotelName: hotelName,
                      morningDays: morningDays,
                      nightDays: nightDays,
                      checkinTime: checkinTime,
                      checkoutTime: checkoutTime,
                      firstName: bookingdetails?.firstName ?? '',
                      lastName: bookingdetails?.secondName ?? '',
                      email: bookingdetails?.email ?? '',
                      mobileNumber: bookingdetails?.contactNumber ?? '',
                      totalPrice: totalPrice,
                    );
                    //generating pdf
                    final pdfFile = await PdfApi.generatePdf(
                      bookingDetails,
                      hotelImage,
                      hotelName,
                    );
                    PdfApi.openFile(pdfFile);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: darkRed),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.download,
                            color: darkRed,
                          ),
                          width5,
                          Text(
                            "save_ticket".tr,
                            style: const TextStyle(
                                color: darkRed, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

//push notification
  // void notfShowing(String hotelName, String name) async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   PushNotificationApi().showSuccessNotificationAfterBook(hotelName, name);
  // }
}

class BookingDetails {
  final String hotelName;
  final String morningDays;
  final String nightDays;
  final String checkinTime;
  final String checkoutTime;
  final String roomsAndmembers;
  final String firstName;
  final String lastName;
  final String email;
  final String? selectedOption;
  final String mobileNumber;
  final String totalPrice;

  BookingDetails({
    required this.hotelName,
    required this.morningDays,
    required this.nightDays,
    required this.checkinTime,
    required this.checkoutTime,
    required this.roomsAndmembers,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.selectedOption,
    required this.mobileNumber,
    required this.totalPrice,
  });
}
