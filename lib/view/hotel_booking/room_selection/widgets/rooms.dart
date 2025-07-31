import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_concierge_tourism/constant/images/demo.dart';
import 'package:e_concierge_tourism/controller/api/hotel_booking/room_details/room_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constant/styles/colors.dart';
import '../../../../constant/styles/textstyle.dart';
import '../../../../getx/hotel_detail_controller.dart';
import '../../hotel_detail/widgets/all_images_of_hotel.dart';
import 'room_details.dart';
import 'room_selection_options.dart';

class Rooms extends StatelessWidget {
  final int index;
  const Rooms({
    super.key,
    required this.roomImages,
    required this.index,
    required this.controller,
    required this.screenWidth,
    required this.screenHeight,
    required this.hotelId,
    required this.roomName,
    required this.roomid,
  });

  final List<String> roomImages;
  final HotelDetailController controller;
  final double screenWidth;
  final double screenHeight;
  final String hotelId;
  final String roomName;
  final int roomid;

  @override
  Widget build(BuildContext context) {
    final RoomDetailController roomdetailController = Get.find();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: PageView.builder(
                  itemCount: 3,
                  onPageChanged: controller.updatePage,
                  itemBuilder: (context, index) {
                    if (roomImages.length < 3) {
                      return const SizedBox(
                        child: Center(child: Text("Room image Not availabale")),
                      );
                    }
                    return CachedNetworkImage(
                      imageUrl: roomImages[index % roomImages.length],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.5,
                      placeholder: (context, url) => Center(
                        child: Image.network(loadingImage),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 12,
              child: Chip(
                shape:
                    const StadiumBorder(side: BorderSide(color: Colors.orange)),
                backgroundColor: Colors.orange,
                label: Text(
                  "top_rated".tr,
                  style: textColorwhite,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 12,
              child: InkWell(
                onTap: () {
                  Get.to(() => AllImagesHotels(images: roomImages));
                },
                child: Chip(
                  shape: const StadiumBorder(),
                  backgroundColor: lightgrey,
                  label: Text(roomImages.length.toString()),
                  avatar: const Icon(Icons.camera_alt),
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: MediaQuery.of(context).size.width / 2 - 40,
              child: Container(
                decoration: const BoxDecoration(
                    color: lightgrey,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Obx(() => Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: index == controller.currentPage.value
                                    ? Colors.blue
                                    : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        RoomDetails(
            index: index,
            roomName: roomName.toUpperCase(),
            sqft: "132 ${"sqft".tr}",
            bed: "double_bed".tr,
            adults:
                "Max ${roomdetailController.rooms[index].totalOccupency} Adult"),

        const Divider(),

        //? Room OPtions--------------------------------------------------------
//room selecting option with meals
        RoomSelectOptions(
            roomId: roomid,
            roomName: roomName,
            hotelId: hotelId,
            roomTypeIndex: index,
            screenWidth: screenWidth,
            screenHeight: screenHeight),
      ],
    );
  }
}
