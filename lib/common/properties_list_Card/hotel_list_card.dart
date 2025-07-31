import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/hotel_list_model.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/styles/colors.dart';
import '../../constant/styles/sizedbox.dart';

class PropertiesListCard extends StatelessWidget {
  final Widget likeButton;
  final String hotelName;
  final Widget hotelImage;
  final VoidCallback ontap;
  final String address;
  final Widget labelName;
  final Widget? offerContainerWidget;
  final String hotelRating;
  final String hotelRating2;
  final double avgRating;
  final VoidCallback sharteButton;
  final Hoteltype? propertyType;

  const PropertiesListCard({
    super.key,
    required this.hotelRating2,
    required this.ontap,
    required this.hotelImage,
    required this.hotelName,
    required this.address,
    required this.labelName,
    this.offerContainerWidget,
    required this.likeButton,
    required this.avgRating,
    required this.hotelRating,
    required this.sharteButton,
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
            child: Stack(
              children: <Widget>[
                InkWell(onTap: ontap, child: hotelImage),
                //! share button-----------
                Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: kBlack,
                    child: IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: sharteButton,
                      color: kWhite,
                    ),
                  ),
                ),
                width10,
                //! like button------
                Positioned(top: 10, right: 55, child: likeButton),
                Positioned(
                  bottom: 10,
                  right: 10,
                  left: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              runSpacing: 5,
                              children: [
                                if (hotelRating.isNotEmpty) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: const BoxDecoration(
                                        color: kWhite,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              getPropertyStarIcon(hotelRating),
                                          width: 20,
                                          height: 20,
                                        ),
                                        width5,
                                        Text(
                                          showPropertyStarText(hotelRating),
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
                                  ),
                                  width10,
                                ],
                                if (propertyType?.icon != null &&
                                    propertyType?.type != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: const BoxDecoration(
                                        color: kWhite,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
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
                                        Flexible(
                                          child: Text(
                                            propertyType!.type!,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                            ),
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
                      if (offerContainerWidget != null) offerContainerWidget!,
                    ],
                  ),
                ),
                //! -----------------------------------
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text(
                  hotelName[0].toUpperCase() + hotelName.substring(1),
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13 * (screenWidth / 375.0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 17,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: 190 * (screenWidth / 365.0),
                      ),
                      child: Text(
                        address,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10 * (screenWidth / 375.0),
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: labelName,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class OfferContainerWidget extends StatelessWidget {
  const OfferContainerWidget({
    super.key,
    required this.roomPrice,
    required this.discountPercentage,
    required this.discountPrice,
  });

  final double roomPrice;
  final double discountPrice;
  final String discountPercentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: kWhite, borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        children: [
          if (discountPercentage.isNotEmpty)
            Container(
              decoration: const BoxDecoration(
                  color: darkRed,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${"Save".tr} $discountPercentage% ${"Today".tr}',
                  style: const TextStyle(color: kWhite, fontSize: 10),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                if (discountPrice > 0) ...[
                  Text(
                    '$roomPrice OMR',
                    style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.black,
                        fontSize: 10),
                  ),
                ],
                width5,
                Text(
                  "${discountPrice > 0 ? discountPrice : roomPrice} OMR + ${"tax".tr}",
                  style: const TextStyle(color: Colors.black, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
