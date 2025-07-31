// import 'package:e_concierge_tourism/constant/texts/code_number.dart';
// import 'package:e_concierge_tourism/controller/api/hotel_booking/success%20details.dart';
// import 'package:e_concierge_tourism/view/bookings/upcoming/upcoming_bookings.dart';
// import 'package:e_concierge_tourism/view/bookings/upcoming/view_more_details_page.dart';
// import 'package:e_concierge_tourism/view/hotel_booking/hotel_detail/widgets/amenities_list.dart';
// import 'package:e_concierge_tourism/widgets/star_ratings/rating_widget.dart';
// import 'package:e_concierge_tourism/widgets/ui_property_details_page_widget/hotel_detail_ui_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../../../constant/images/hotels_booking.dart';
// import '../../../constant/styles/colors.dart';
// import '../../../controller/api/hotel_booking/hotel_detail.dart';
// import '../../../controller/getx/hotel_detail_controller.dart';
// import '../../../model/success_booking/success_booking_model.dart';
// import '../../hotel_booking/hotel_detail/widgets/all_images_of_hotel.dart';

// class CompletedBookingDetails extends StatelessWidget {
//   final String hotelName;
//   final String hotelcityname;
//   final String morningdays;
//   final String nightdays;
//   final String checkindate;
//   final String checkout;
//   final String guestInfo;
//   final List<RoomDetails> roomDetails;
//   final int bookingId;

//   CompletedBookingDetails(
//       {super.key,
//       required this.hotelName,
//       required this.hotelcityname,
//       required this.morningdays,
//       required this.nightdays,
//       required this.checkindate,
//       required this.checkout,
//       required this.guestInfo,
//       required this.roomDetails,
//       required this.bookingId});
//   final HotelDetailController _controller = Get.put(HotelDetailController());

//   final HotelDetailsControllerApi apiController =
//       Get.put(HotelDetailsControllerApi());
//   final RxDouble latitude = 0.0.obs;
//   final RxDouble longitude = 0.0.obs;
//   void aa() async {
//     List<Location> locations = await locationFromAddress(hotelcityname);
//     if (locations.isNotEmpty) {
//       latitude.value = locations[0].latitude;
//       longitude.value = locations[0].longitude;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     Get.put(BookingSuccessApiDetails());
//     aa();
//     return Scaffold(
//       appBar: AppBar(),
//       body: ViewMoreDetailsPage(
//           hotelName: hotelName,
//           hotelcityname: hotelcityname,
//           morningdays: morningdays,
//           nightdays: nightdays,
//           checkindate: checkindate,
//           checkout: checkout,
//           guestInfo: guestInfo,
//           roomDetails: roomDetails),
//       // body: ListView(
//       //   children: [
//       //     Stack(
//       //       children: [
//       //         SizedBox(
//       //           height: MediaQuery.of(context).size.height * 0.3,
//       //           child: PageView.builder(
//       //             itemCount: 3,
//       //             onPageChanged: _controller.updatePage,
//       //             itemBuilder: (context, index) {
//       //               return Image.network(hotelImage[index % hotelImage.length],
//       //                   fit: BoxFit.cover,
//       //                   width: double.infinity,
//       //                   height: MediaQuery.of(context).size.height * 0.5);
//       //             },
//       //           ),
//       //         ),
//       //         Positioned(
//       //           bottom: 10,
//       //           right: 10,
//       //           child: GestureDetector(
//       //             onTap: () =>
//       //                 Get.to(() => AllImagesHotels(images: hotelImage)),
//       //             child: Chip(
//       //               label: Text(hotelImage.length.toString()),
//       //               avatar: const Icon(Icons.camera_alt),
//       //             ),
//       //           ),
//       //         ),
//       //         Positioned(
//       //           bottom: 15,
//       //           left: MediaQuery.of(context).size.width / 2 - 40,
//       //           child: Container(
//       //             decoration: const BoxDecoration(
//       //                 color: lightgrey,
//       //                 borderRadius: BorderRadius.all(Radius.circular(10))),
//       //             child: Padding(
//       //               padding: const EdgeInsets.all(5.0),
//       //               child: Row(
//       //                 mainAxisAlignment: MainAxisAlignment.center,
//       //                 children: List.generate(
//       //                   3,
//       //                   (index) => Padding(
//       //                     padding: const EdgeInsets.symmetric(horizontal: 5),
//       //                     child: Obx(() => Container(
//       //                           width: 10,
//       //                           height: 10,
//       //                           decoration: BoxDecoration(
//       //                             color: index == _controller.currentPage.value
//       //                                 ? Colors.blue
//       //                                 : Colors.grey,
//       //                             shape: BoxShape.circle,
//       //                           ),
//       //                         )),
//       //                   ),
//       //                 ),
//       //               ),
//       //             ),
//       //           ),
//       //         ),
//       //       ],
//       //     ),
//       //     Padding(
//       //       padding: const EdgeInsets.all(5.0),
//       //       child: HotelUi(
//       //         viewAllAmenitiesOntap: () {},
//       //         amenitiesList: const AmenitiesList(
//       //           amenities: [],
//       //         ),
//       //         abouttheproperty: "",
//       //         ontap: () {},
//       //         hotelCityName: hotelcityname.toUpperCase(),
//       //         completedDetailsWidgetAddCodeNumber:
//       //             completedDetailsWidgetAddCodeNumber,
//       //         reviewScore1: "5.9 ${"review_Score".tr} ",
//       //         reviewScore2: "268 ${"Reviews".tr}",
//       //         rating: const RatingWidget(rating: 4),
//       //         editButtontextcolor: kBlack,
//       //         color: Colors.orange,
//       //         hotelName: hotelName.toUpperCase(),
//       //         googleMap: Obx(
//       //           () {
//       //             double lat = latitude.value;
//       //             double long = longitude.value;
//       //             if (lat == 0.0 || long == 0.0) {
//       //               return const SizedBox(
//       //                 height: 150,
//       //                 child: Center(child: CircularProgressIndicator()),
//       //               );
//       //             }

//       //             LatLng googlePlex = LatLng(lat, long);

//       //             return SizedBox(
//       //               height: 150,
//       //               child: InkWell(
//       //                 onTap: () async {},
//       //                 child: GoogleMap(
//       //                   initialCameraPosition:
//       //                       CameraPosition(target: googlePlex, zoom: 14.0),
//       //                   markers: {
//       //                     Marker(
//       //                       markerId: const MarkerId("city_name"),
//       //                       icon: BitmapDescriptor.defaultMarker,
//       //                       position: googlePlex,
//       //                     ),
//       //                   },
//       //                   onMapCreated: (GoogleMapController controller) {},
//       //                 ),
//       //               ),
//       //             );
//       //           },
//       //         ),
//       //       ),
//       //     ),
//       //   ],
//       // ),
//     );
//   }
// }
