import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_concierge_tourism/common/capitalized_word/capitialize_word.dart';
import 'package:e_concierge_tourism/common/properties_list_Card/hotel_list_card.dart';
import 'package:e_concierge_tourism/constant/images/demo.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/hotel_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/styles/colors.dart';
import '../../../constant/styles/icons.dart';
import '../../../constant/styles/sizedbox.dart';
import '../../../constant/styles/textstyle.dart';

class ChaletsList extends StatelessWidget {
  final VoidCallback shareButton;
  final String hotelName;
  final String hotelImage;
  final VoidCallback ontap;
  final String address;
  final Widget likeButton;
  final double price;
  final String rating;
  final String rating2;
  final String tax;
  final Widget trailing;
  final String discountPercentage;
  final double discountedPrice;
  final Hoteltype? propertyType;
  const ChaletsList({
    super.key,
    required this.ontap,
    required this.hotelImage,
    required this.hotelName,
    required this.address,
    required this.likeButton,
    required this.price,
    required this.rating,
    required this.rating2,
    required this.tax,
    required this.shareButton,
    required this.trailing,
    required this.discountPercentage,
    required this.discountedPrice,
    required this.propertyType,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
          color: lightgrey,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: Stack(children: <Widget>[
              InkWell(
                onTap: ontap,
                child: CachedNetworkImage(
                  imageUrl: hotelImage,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: Image.network(loadingImage),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/images/property_placeholder.png",
                    fit: BoxFit.contain,
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Opacity(
                  opacity: 0.8,
                  child: CircleAvatar(
                    backgroundColor: kBlack,
                    child: IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: shareButton,
                      color: kWhite,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 55,
                child: Opacity(
                  opacity: 0.8,
                  child: likeButton,
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            runSpacing: 5,
                            children: [
                              if (propertyType?.icon != null &&
                                  propertyType?.type != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: const BoxDecoration(
                                      color: kWhite,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CachedNetworkImage(
                                        width: 20,
                                        height: 20,
                                        imageUrl: propertyType!.icon!,
                                        errorWidget: (context, url, error) =>
                                            const SizedBox.shrink(),
                                      ),
                                      // Image.network(
                                      //   propertyType!.icon!,
                                      //   width: 20,
                                      //   height: 20,
                                      // ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        propertyType!.type!,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      )
                                      // RichText(
                                      //   text: TextSpan(
                                      //     children: [
                                      //       TextSpan(
                                      //         text:
                                      //             '$hotelRating ${getRatingText(avgRating)}',
                                      //         style: const TextStyle(
                                      //             color: Colors.white, fontSize: 11),
                                      //       ),
                                      //       TextSpan(
                                      //           text: ' ($hotelRating2 ${"ratings".tr}) ',
                                      //           style: textColorwhite.copyWith(fontSize: 10)),
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ],
                      ),
                    ),
                    OfferContainerWidget(
                      discountPrice: discountedPrice,
                      discountPercentage: discountPercentage,
                      roomPrice: price,
                    )
                  ],
                ),
              ),
              // Positioned(
              //   bottom: 10,
              //   right: 19,
              //   child: Container(
              //     decoration: const BoxDecoration(
              //         color: kWhite,
              //         borderRadius: BorderRadius.all(Radius.circular(8))),
              //   ),
              // ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 210 * (screenWidth / 375.0),
                    ),
                    child: Text(
                      hotelName.toUpperCase().tr,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13 * (screenWidth / 375.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 17,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          capitalizeFirstLetter(address),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10 * (screenWidth / 375.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      trailing,
                    ],
                  ),
                  height5,
                  //? compare button----------------------------------------------------------------------
                  // Align(
                  //   heightFactor: 0.3,
                  //   alignment: hotelDetail_compare_button == false
                  //       ? Alignment.bottomRight
                  //       : Alignment.bottomLeft,
                  //   child: Column(
                  //     children: [
                  //       Container(
                  //         margin: const EdgeInsets.only(right: 5),
                  //         decoration: const BoxDecoration(
                  //             color: darkRed,
                  //             borderRadius:
                  //                 BorderRadius.all(Radius.circular(15))),
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Text(
                  //             offer,
                  //             style:
                  //                 const TextStyle(color: kWhite, fontSize: 10),
                  //           ),
                  //         ),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: RichText(
                  //           overflow: TextOverflow.ellipsis,
                  //           text: TextSpan(
                  //             children: [
                  //               TextSpan(
                  //                 text: price,
                  //                 style: const TextStyle(
                  //                   color: Colors.black,
                  //                   fontSize: 16,
                  //                   fontWeight: FontWeight.bold,
                  //                 ),
                  //               ),
                  //               TextSpan(
                  //                 text: tax,
                  //                 style: const TextStyle(
                  //                   color: Colors.black,
                  //                   fontSize: 7,
                  //                   fontWeight: FontWeight.bold,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
