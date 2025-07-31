import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/controller/api/hotel_booking/room_details/room_details.dart';
import 'package:e_concierge_tourism/getx/roomtype_select.dart';
import 'package:intl/intl.dart';
import '../../../constant/styles/colors.dart';
import 'package:e_concierge_tourism/view/hotel_booking/components/bottom_nav_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/styles/textstyle.dart';
import '../../../getx/count_of_guest.dart';
import '../../../getx/date_picker_controller.dart';
import '../../../getx/hotel_detail_controller.dart';
import '../../../getx/room_controller.dart';
import '../../../controller/model/hotel_bookings/hotel_booking_entire/room_details.dart';
import '../components/app_bar.dart';
import '../reviewbooking/review_booking.dart';
import 'widgets/rooms.dart';

class RoomSelection extends StatelessWidget {
  final double countryTax;
  final int hotelId;
  final String hotelImage;
  final String hotelname;
  final int? promoId;
  RoomSelection(
      {super.key,
      required this.hotelname,
      required this.hotelImage,
      required this.hotelId,
      required this.countryTax,
      this.promoId});
//*---------------------------------------------------------------------------------
  late bool apicall = true;
  final RoomDetailController roomdetailController =
      Get.put(RoomDetailController());
  final HotelDetailController controller = Get.put(HotelDetailController());
  final RoomTypeController roomtypeController = Get.put(RoomTypeController());
  RoomsController roomController = Get.put(RoomsController());
  final DatePickerController datePickercontroller = Get.find();
  final CounterController counterControllerFind = Get.find();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    final noOfRooms = counterControllerFind.counters[0].toString();
    final adults = counterControllerFind.counters[1];
    final members = adults + counterControllerFind.counters[2];
    String rooms =
        "$noOfRooms ${"room".tr}, $adults ${"adult".tr}${counterControllerFind.counters[2] >= 0 ? ', ${counterControllerFind.counters[2]} ${"children".tr}' : ''}";
    if (apicall) {
      final checkinDate = DateFormat('yyyy-MM-dd')
          .format(datePickercontroller.selectedStartDate.value);
      final checkoutDate = DateFormat('yyyy-MM-dd')
          .format(datePickercontroller.selectedEndDate.value);
      roomdetailController.fetchRooms(hotelId.toString(), noOfRooms,
          members.toString(), checkinDate, checkoutDate);
      // print(datePickercontroller.selectedStartDate.value);
      apicall = false;
    }
    //!------------------------------------------------------------------------

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Appbar(
          peopleIcon: Icons.people,
          adults: rooms,
          subtitle:
              "${datePickercontroller.getFormattedDate(datePickercontroller.selectedStartDate.value)} - ${datePickercontroller.getFormattedDate(datePickercontroller.selectedEndDate.value)}",
          trailingTitle: "",
          title: hotelname[0].toUpperCase() + hotelname.substring(1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        child: Column(
          children: [
            // /  height10,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     InkWell(
            //       onTap: () {
            //         showMenu<String>(
            //           color: kWhite,
            //           context: context,
            //           position: RelativeRect.fromLTRB(
            //             screenSize.width *
            //                 0.40, // 50% from the left of the screen
            //             screenSize.height *
            //                 0.17, // 25% from the top of the screen
            //             screenSize.width *
            //                 0.40, // 10% from the right of the screen
            //             screenSize.height *
            //                 0.1, // 10% from the bottom of the screen
            //           ),
            //           items: [
            //             const PopupMenuItem<String>(
            //               value: "STANDARD",
            //               child: Text("STANDARD"),
            //             ),
            //             PopupMenuItem<String>(
            //               value: "DELUXE".tr,
            //               child: const Text("DELUXE"),
            //             ),
            //             PopupMenuItem<String>(
            //               value: "SUITE".tr,
            //               child: const Text("SUITE"),
            //             ),
            //           ],
            //           elevation: 8.0,
            //         ).then((value) {
            //           if (value != null) {
            //             roomtypeController.selectPropertyType(value);
            //           }
            //         });
            //       },
            //       child: Obx(
            //         () => SortFilterPriceButton(
            //             text: roomtypeController.selectRoomType.value,
            //             icon: Icons.sort,
            //             arrowdown: Icons.keyboard_arrow_down),
            //       ),
            //     ),
            //   ],
            // ),
            //height20,
            //* rooms---------------------------------------------------------------------------

            Expanded(
              child: Obx(() {
                List<Room> sortedRooms;

                if (roomdetailController.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final roomDetails = roomdetailController.rooms
                    .where((room) => room.hotelId == hotelId)
                    .toList();

                switch (roomtypeController.selectRoomType.value) {
                  case "SUITE":
                    sortedRooms = roomDetails
                        .where((room) => room.roomTypeName == "SUITE")
                        .toList();
                    break;
                  case "STANDARD":
                    sortedRooms = roomDetails
                        .where((room) => room.roomTypeName == "STANDARD")
                        .toList();
                    break;
                  case "DELUXE":
                    sortedRooms = roomDetails
                        .where((room) => room.roomTypeName == "DELUXE")
                        .toList();
                    break;
                  default:
                    sortedRooms = roomDetails;
                }

                if (sortedRooms.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Image.asset("assets/emptyImage/Group 1000001751.png"),
                          const SizedBox(height: 30),
                          Text(
                            "No Rooms available right now".tr,
                            style: const TextStyle(color: kGrey),
                          )
                        ],
                      ),
                    ),
                  );
                }

                //Room list showing
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height5,
                      // const Text(
                      //     'The prices mentioned below exclusive of taxes and charges'),
                      ...List.generate(sortedRooms.length, (index) {
                        final room = sortedRooms[index];

                        return Card(
                          color: Colors.white,
                          //widget
                          child: Rooms(
                            roomid: room.id!,
                            roomName: room.roomTypeName!,
                            hotelId: hotelId.toString(),
                            index: index,
                            roomImages: room.roomImage,
                            controller: controller,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                        );
                      })
                      // ListView.separated(
                      //   itemCount: sortedRooms.length,
                      //   separatorBuilder: (context, index) =>
                      //       const SizedBox(height: 10),
                      //   itemBuilder: (context, index) {
                      //     final room = sortedRooms[index];
                      //     return Card(
                      //       color: Colors.white,
                      //       //widget
                      //       child: Rooms(
                      //         roomid: room.id!,
                      //         roomName: room.roomTypeName!,
                      //         hotelId: hotelId.toString(),
                      //         index: index,
                      //         roomImages: room.roomImage,
                      //         controller: controller,
                      //         screenWidth: screenWidth,
                      //         screenHeight: screenHeight,
                      //       ),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),

      //? bottom nav ---------------------------------------------------------

      bottomNavigationBar: Obx(
        () {
          List<Room> sortedRooms;

          if (roomdetailController.loading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final roomDetails = roomdetailController.rooms
              .where((room) => room.hotelId == hotelId)
              .toList();

          switch (roomtypeController.selectRoomType.value) {
            case "SUITE":
              sortedRooms = roomDetails
                  .where((room) => room.roomTypeName == "SUITE")
                  .toList();
              break;
            case "STANDARD":
              sortedRooms = roomDetails
                  .where((room) => room.roomTypeName == "STANDARD")
                  .toList();
              break;
            case "DELUXE":
              sortedRooms = roomDetails
                  .where((room) => room.roomTypeName == "DELUXE")
                  .toList();
              break;
            default:
              sortedRooms = roomDetails;
          }

          int selectedRoomCount = roomController.roomsWithMeal.length;
          double totalPrice = 0.0;

          for (var element in roomController.roomsWithMeal) {
            String? roomTypePrice = element.price;
            totalPrice += double.parse(roomTypePrice);
          }

          return BottomNavButton(
            style: textBoldblack.copyWith(fontSize: 17),
            price: "${totalPrice.toStringAsFixed(2)} OMR + Tax",
            buttonName: sortedRooms.isNotEmpty
                ? Text(
                    "continue".tr,
                    style: const TextStyle(color: kWhite, fontSize: 15),
                  )
                : Text(
                    "SOLD OUT".tr,
                    style: const TextStyle(color: kWhite, fontSize: 15),
                  ),
            ontap: () {
              if (selectedRoomCount > 0) {
                Get.to(() => ReviewBooking(
                      countryTax: countryTax,
                      roomParticularPrice: roomController.roomsWithMeal
                          .map((element) => element.price)
                          .toList(),
                      roomImage: roomdetailController.rooms[0].roomImage,
                      hotelId: hotelId.toString(),
                      roomTotalPrice: totalPrice.toStringAsFixed(2),
                      // roomOptionListID: roomController.roomOptionNameIDList,
                      roomListID: roomController.roomsWithMeal
                          .map((element) => element.roomId)
                          .toList(),
                      hotelIdsss: hotelId.toString(),
                      hotelImage: hotelImage,
                      hotelName: hotelname,
                      promoId: promoId,
                    ));
              } else {
                sortedRooms.isNotEmpty
                    ? Get.snackbar(
                        backgroundColor: kBlack,
                        colorText: kWhite,
                        "Room selection failed".tr,
                        "Please select a room to proceed".tr,
                        snackStyle: SnackStyle.FLOATING,
                      )
                    : Get.snackbar(
                        "Sorry for the inconvenience".tr,
                        backgroundColor: darkRed,
                        colorText: kWhite,
                        "We apologize, but there are no rooms available during your chosen dates. Please select alternative dates or browse other available accommodations."
                            .tr);
              }
            },
          );
        },
      ),
    );
  }
}
