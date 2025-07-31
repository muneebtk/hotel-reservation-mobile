import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_concierge_tourism/common/capitalized_word/capitialize_word.dart';
import 'package:e_concierge_tourism/constant/images/demo.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:e_concierge_tourism/controller/api/chalets_booking/chalet_list_and_detail/chalet_search_api.dart';
import 'package:e_concierge_tourism/view/home/widgets/heading_text.dart';
import 'package:e_concierge_tourism/view/hotel_booking/hotel_detail/widgets/amenities_list.dart';
import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/api/hotel_booking/hotel_detail/hotel_detail.dart';

class AboutTheProperty extends StatelessWidget {
  final String hotelid;
  final String text;
  final String contactNumber;

  AboutTheProperty(
      {super.key,
      required this.hotelid,
      required this.text,
      required this.contactNumber});
  final HotelDetailsControllerApi apiController =
      Get.put(HotelDetailsControllerApi());

  @override
  Widget build(BuildContext context) {
    final data = apiController.hotelDetails.value;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // List<String> roomTypes = ['Single Room', 'Deluxe Room', 'Family Room'];
    List<String> roomTypes = <String>[].obs;
    roomTypes.addAll(apiController.hotelDetails.value.roomtypeName);
    return Scaffold(
      appBar: MyAppBar(title: 'hotel_detail'.tr),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: data.hotelImage[0],
                      placeholder: (context, url) =>
                          Image.network(loadingImage),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                HeadingText(heading: 'about_the_property'.tr),
                SizedBox(height: screenHeight * 0.005),
                Text(text),
                SizedBox(height: screenHeight * 0.015),
                Card(
                  elevation: 7,
                  color: kWhite,
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   'Property details'.tr,
                          //   style: textBoldblack,
                          // ),
                          // SizedBox(height: screenHeight * 0.01),
                          ListTile(
                            minVerticalPadding: 0,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.apartment,
                              color: darkRed,
                            ),
                            title: Text('Hotel name'.tr,
                                style: textBoldblack.copyWith(fontSize: 15)),
                            subtitle: Text(
                              data.name.length > 30
                                  ? '${data.name[0].toUpperCase() + data.name.substring(1, 30)}…'
                                  : data.name[0].toUpperCase() +
                                      data.name.substring(1),
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ListTile(
                            minTileHeight: 20,
                            minVerticalPadding: 0,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.phone,
                              color: darkRed,
                            ),
                            title: Text('Contact'.tr,
                                style: textBoldblack.copyWith(fontSize: 15)),
                            subtitle: Text(
                              contactNumber,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          ListTile(
                            minVerticalPadding: 0,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.location_on,
                              color: darkRed,
                            ),
                            title: Text('Address'.tr,
                                style: textBoldblack.copyWith(fontSize: 15)),
                            subtitle: Text(
                              data.address,
                            ),
                          ),
                          ListTile(
                            minTileHeight: 20,
                            minVerticalPadding: 0,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.bedroom_child_sharp,
                              color: darkRed,
                            ),
                            title: Text('Number of rooms'.tr,
                                style: textBoldblack.copyWith(fontSize: 15)),
                            subtitle: Text(
                              "${'Total'.tr} ${data.numberOfRooms.toString()} ${'Rooms'.tr}",
                            ),
                          ),
                          height10,
                          ListTile(
                            minTileHeight: 20,
                            minVerticalPadding: 0,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.bedroom_child_sharp,
                              color: darkRed,
                            ),
                            title: Text("Available rooms".tr,
                                style: textBoldblack.copyWith(fontSize: 15)),
                            subtitle: Text(
                              "${data.roomsAvailable.toString()} ${"Rooms available".tr}",
                            ),
                          ),
                          height10,
                          ListTile(
                            minTileHeight: 20,
                            minVerticalPadding: 0,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.rate_review_outlined,
                              color: darkRed,
                            ),
                            title: Text("Ratings".tr,
                                style: textBoldblack.copyWith(fontSize: 15)),
                            subtitle: Text(
                              "${data.hotelRating.toString()} ratings about the ${data.name} ",
                            ),
                          ),
                          Wrap(
                            spacing: screenWidth * 0.02,
                            runSpacing: screenHeight * 0.01,
                            children: roomTypes.map((type) {
                              return Chip(
                                color: const WidgetStatePropertyAll(kWhite),
                                label: Text(
                                  type,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                Text('All Amenities'.tr),
                Obx(() {
                  var amenities = apiController.hotelDetails.value.amenities;

                  if (amenities.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text("No amenities available".tr),
                    );
                  }

                  List<AmenityS> staticAmenities = amenities.map((data) {
                    return AmenityS(data.icon, data.name);
                  }).toList();
                  if (staticAmenities.isNotEmpty) {
                    List<AmenityS> firstThreeAmenities =
                        staticAmenities.take(3).toList();
                    List<AmenityS> remainingAmenities =
                        staticAmenities.skip(3).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (firstThreeAmenities.isNotEmpty)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: firstThreeAmenities.map((amenity) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton.icon(
                                    style: ButtonStyle(
                                        shape: const WidgetStatePropertyAll(
                                            ContinuousRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)))),
                                        backgroundColor:
                                            WidgetStatePropertyAll(kGrey[100])),
                                    onPressed: () {},
                                    label: Text(
                                      amenity.text.toString()[0].toUpperCase() +
                                          amenity.text.substring(1),
                                      style: const TextStyle(
                                          fontSize: 12, color: kBlack),
                                    ),
                                    icon: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: kWhite,
                                      backgroundImage:
                                          NetworkImage(amenity.icon),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        if (remainingAmenities.isNotEmpty)
                          Text('Other amenities'.tr),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: remainingAmenities.map((amenity) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton.icon(
                                onPressed: () {},
                                label: Text(
                                  amenity.text,
                                  style: const TextStyle(color: kBlack),
                                ),
                                icon: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: kWhite,
                                  backgroundImage: NetworkImage(amenity.icon),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//-------------- chalet ---------------------------------------------

class AboutThePropertyChalet extends StatelessWidget {
  final String hotelid;
  final String text;
  final String amenityText;
  final String icon;
  final String contactNumber;

  AboutThePropertyChalet(
      {super.key,
      required this.hotelid,
      required this.text,
      required this.amenityText,
      required this.icon,
      required this.contactNumber});

  final ChaletSearchApi apiController = Get.put(ChaletSearchApi());
  final ChaletSearchApi chalestDetailController = Get.find();

  @override
  Widget build(BuildContext context) {
    final chaletdetails = chalestDetailController.chaletListDetail;
    final data = chalestDetailController.chaletListDetail[0];

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: MyAppBar(title: 'Chalet Detail'.tr),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: data.mainImage.toString(),
                      placeholder: (context, url) =>
                          Image.network(loadingImage),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                HeadingText(heading: 'about_the_property'.tr),
                SizedBox(height: screenHeight * 0.005),
                Text(text),
                SizedBox(height: screenHeight * 0.015),

                Card(
                  elevation: 7,
                  color: kWhite,
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   'Property details'.tr,
                          //   style: textBoldblack,
                          // ),
                          // SizedBox(height: screenHeight * 0.01),
                          ListTile(
                            minVerticalPadding: 0,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.apartment,
                              color: darkRed,
                            ),
                            title: Text('Chalet Name'.tr,
                                style: textBoldblack.copyWith(fontSize: 15)),
                            subtitle: Text(
                              data.name.toString(),
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ListTile(
                            minTileHeight: 20,
                            minVerticalPadding: 0,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.phone,
                              color: darkRed,
                            ),
                            title: Text('Contact'.tr,
                                style: textBoldblack.copyWith(fontSize: 15)),
                            subtitle: Text(
                              contactNumber,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          height5,
                          ListTile(
                            minVerticalPadding: 0,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.location_on,
                              color: darkRed,
                            ),
                            title: Text('Address'.tr,
                                style: textBoldblack.copyWith(fontSize: 15)),
                            subtitle: Text(
                              data.address.toString(),
                            ),
                          ),
                          // ListTile(
                          //   minTileHeight: 20,
                          //   minVerticalPadding: 0,
                          //   contentPadding: EdgeInsets.zero,
                          //   leading: const Icon(
                          //     Icons.bedroom_child_sharp,
                          //     color: darkRed,
                          //   ),
                          //   title: Text('Number of rooms'.tr,
                          //       style: textBoldblack.copyWith(fontSize: 15)),
                          //   subtitle: Text(
                          //     "${data.numberOfRooms.toString()} Rooms Available",
                          //   ),
                          // ),
                          height10,
                          // ListTile(
                          //   minTileHeight: 20,
                          //   minVerticalPadding: 0,
                          //   contentPadding: EdgeInsets.zero,
                          //   leading: const Icon(
                          //     Icons.rate_review_outlined,
                          //     color: darkRed,
                          //   ),
                          //   title: Text('Ratings'.tr,
                          //       style: textBoldblack.copyWith(fontSize: 15)),
                          //   subtitle: Text(
                          //     "${data. .toString()} ratings about the ${data.name} ",
                          //   ),
                          // ),
                          // Wrap(
                          //   spacing: screenWidth * 0.02,
                          //   runSpacing: screenHeight * 0.01,
                          //   children: roomTypes.map((type) {
                          //     return Chip(
                          //       color: const WidgetStatePropertyAll(kWhite),
                          //       label: Text(
                          //         type,
                          //         overflow: TextOverflow.ellipsis,
                          //       ),
                          //     );
                          //   }).toList(),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //       border: Border.all(color: kBlack),
                //       borderRadius: BorderRadius.circular(10)),
                //   child: Padding(
                //     padding: EdgeInsets.all(screenWidth * 0.02),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           'Property details'.tr,
                //           style: textBoldblack,
                //         ),
                //         SizedBox(height: screenHeight * 0.01),
                //         Obx(() {
                //           final data = apiController.chaletListDetail.isNotEmpty
                //               ? apiController.chaletListDetail[0]
                //               : null;
                //           if (data == null) {
                //             return Center(child: Text("No details available".tr));
                //           }
                //           return Column(
                //             children: [
                //               ListTile(
                //                 minTileHeight: 35,
                //                 minVerticalPadding: 0,
                //                 contentPadding: EdgeInsets.zero,
                //                 leading: const Icon(Icons.apartment),
                //                 title: Text('Chalet Name'.tr),
                //                 trailing: Text(
                //                   data.name.toString().toUpperCase(),
                //                   overflow: TextOverflow.ellipsis,
                //                 ),
                //               ),
                //               ListTile(
                //                 minTileHeight: 45,
                //                 minVerticalPadding: 0,
                //                 contentPadding: EdgeInsets.zero,
                //                 leading: const Icon(Icons.phone),
                //                 title: Text('Contact'.tr),
                //                 trailing: const Text(
                //                   "+968 8723544",
                //                 ),
                //               ),
                //               ListTile(
                //                 minTileHeight: 35,
                //                 contentPadding: EdgeInsets.zero,
                //                 leading: const Icon(Icons.location_on),
                //                 title: Text('Address'.tr),
                //                 trailing: Expanded(
                //                   child: Text(data.cityName.toString(),
                //                       style:
                //                           textBoldblack.copyWith(fontSize: 14)),
                //                 ),
                //               ),
                //             ],
                //           );
                //         }),
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(height: screenHeight * 0.015),
                Text('   ${"All Amenities".tr}'),
                height10,
                ListView.separated(
                  separatorBuilder: (context, index) => height10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.amenities!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      minTileHeight: 15,
                      leading: CircleAvatar(
                        radius: 15,
                        backgroundColor: kWhite,
                        backgroundImage: NetworkImage(
                          data.amenities![index].icon,
                        ),
                        // child: Image.network(
                        //   height: 25,
                        // ),
                      ),
                      title: Text(
                        capitalizeFirstLetter(data.amenities![index].name),
                        style: const TextStyle(fontSize: 13),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
