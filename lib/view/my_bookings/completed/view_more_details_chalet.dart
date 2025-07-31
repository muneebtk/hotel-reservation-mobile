// import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
// import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
// import 'package:e_concierge_tourism/controller/model/hotel_bookings/upcoming_section_hotel/completed.dart';
// import 'package:e_concierge_tourism/view/my_bookings/completed/rating_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../controller/api/upcoming_section/success_details.dart';
// import '../../hotel_booking/reviewbooking/widgets/review_hotel.dart';

// class ViewMoreDetailsPageChalet extends StatefulWidget {
//   final String hotelName;
//   final String hotelcityname;
//   final String bookingID;
//   final String checkindate;
//   final String checkout;
//   final String guestInfo;
//   final String? hotelId;
//   final String? codeCompletedDetails;
//   final String image;
//   final String? chaletCHECK;
//   final UserRatingReview? userRating;

//   const ViewMoreDetailsPageChalet(
//       {super.key,
//       required this.bookingID,
//       required this.hotelName,
//       required this.hotelcityname,
//       required this.checkindate,
//       required this.checkout,
//       required this.guestInfo,
//       this.hotelId,
//       this.codeCompletedDetails,
//       required this.image,
//       this.chaletCHECK,
//       required this.userRating});

//   @override
//   ViewMoreDetailsPageState createState() => ViewMoreDetailsPageState();
// }

// class ViewMoreDetailsPageState extends State<ViewMoreDetailsPageChalet> {
//   late BookingSuccessApiDetails bookingController;
//   @override
//   void initState() {
//     super.initState();
//     bookingController = Get.put(BookingSuccessApiDetails());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final width = size.width;
//     final height = size.height;
//     return Scaffold(
//       appBar: MyAppBar(
//           title: widget.hotelName[0].toUpperCase() +
//               widget.hotelName.substring(1)),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: ListView(
//           children: [
//             Card(
//               color: Colors.white,
//               child: ReviewHotel(
//                 checkinDate:
//                     bookingController.bookingDetails.value.value?.checkin,
//                 checkoutDate:
//                     bookingController.bookingDetails.value.value?.checkout,
//                 chaletCheck: widget.chaletCHECK,
//                 hotelCityName: widget.hotelcityname.toUpperCase(),
//                 hotelName: widget.hotelName.toUpperCase(),
//                 image: widget.image,
//                 morningDays: "2 Morning",
//                 nightDays: "1 Nights",
//                 width: width,
//                 height: height,
//                 checkIndate: widget.checkindate,
//                 checkoutdate: widget.checkout,
//                 guestInfo: "${widget.guestInfo} Guests & 2 Members",
//               ),
//             ),
//             height10,
//             height10,
//             if (widget.codeCompletedDetails == '1')
//               Rating(
//                 bookingID: widget.bookingID,
//                 propertyID: widget.hotelId.toString(),
//                 check: "CHALET",
//                 hotelId: widget.hotelId.toString(),
//                 userRating: widget.userRating,
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }
