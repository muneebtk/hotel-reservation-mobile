import 'package:e_concierge_tourism/common/capitalized_word/capitialize_word.dart';
import 'package:e_concierge_tourism/controller/api/hotel_booking/hotel_detail/hotel_detail.dart';
import 'package:e_concierge_tourism/controller/api/nearby_places/nearby_places.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/hotel_details.dart';
import 'package:e_concierge_tourism/common/ui_property_details_page_widget/property_rules.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:e_concierge_tourism/view/home/widgets/discout_offer.dart';
import 'package:e_concierge_tourism/view/home/widgets/heading_text.dart';
import 'package:e_concierge_tourism/common/ui_property_details_page_widget/nearby_place_widget.dart';
import 'package:e_concierge_tourism/common/ui_property_details_page_widget/ratings_widget.dart';
import 'package:e_concierge_tourism/view/hotel_booking/hotel_detail/widgets/amenities_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../../constant/styles/colors.dart';
import '../../constant/styles/sizedbox.dart';
import '../../constant/styles/textstyle.dart';
import '../../getx/count_of_guest.dart';
import '../../getx/date_picker_controller.dart';
import '../../view/hotel_booking/search_hotels/widgets/date_picker_screen.dart';

class HotelUi extends StatelessWidget {
  final String? chaletCheck;
  final String? completedDetailsWidgetAddCodeNumber;
  final Color? editButtontextcolor;
  final Color? color;
  final String hotelName;
  final Widget rating;
  final String reviewScore1;
  final String reviewScore2;
  final VoidCallback ontap;
  final Widget googleMap;
  final String hotelCityName;
  final String abouttheproperty;
  final List<AmenityS> amenitiesList;
  final VoidCallback viewAllAmenitiesOntap;
  final VoidCallback allreviewButton;
  final VoidCallback aboutPropertyButton;
  final String hotelId;
  final String totalNumberOfReview;
  final String totalNumberOfRating;
  final double averageRating;
  final List<Review> reviews;
  final List<Offer> offers;
  final LatLng latLng;
  final String checkin;
  final String checkout;
  final List<int> ratings;
  const HotelUi({
    super.key,
    required this.amenitiesList,
    required this.hotelName,
    required this.color,
    required this.editButtontextcolor,
    required this.rating,
    required this.reviewScore1,
    required this.reviewScore2,
    this.completedDetailsWidgetAddCodeNumber,
    required this.ontap,
    required this.googleMap,
    required this.hotelCityName,
    required this.abouttheproperty,
    required this.viewAllAmenitiesOntap,
    required this.allreviewButton,
    required this.hotelId,
    required this.aboutPropertyButton,
    required this.totalNumberOfReview,
    required this.totalNumberOfRating,
    required this.averageRating,
    required this.reviews,
    this.chaletCheck,
    required this.offers,
    required this.latLng,
    required this.checkin,
    required this.checkout,
    required this.ratings,
  });

  @override
  Widget build(BuildContext context) {
    ChaletNearbyControllerr chaletNearbyController =
        Get.put(ChaletNearbyControllerr());
    CounterController counterControllerFind = Get.find();
    DatePickerController datePickercontroller = Get.find();
    HotelDetailsControllerApi apiController = Get.find();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //? Hotel name, ratings, and location----------------------

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  overflow: TextOverflow.visible,
                  hotelName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              InkWell(
                onTap: ontap,
                child: Container(
                  decoration: BoxDecoration(
                    color: darkRed,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'chat_with_us'.tr,
                      style: textColorwhite.copyWith(fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          //! Rating widget-----------------------------------------------------
          rating,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: <Widget>[
                  const Icon(Icons.location_on, color: Colors.grey),
                  Text(hotelCityName),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height10,
                  Text(
                    reviewScore1,
                    style: textColorblack.copyWith(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    reviewScore2,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  )
                ],
              )
            ],
          ),
          height20,
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Obx(
                    () => Text(
                        overflow: TextOverflow.ellipsis,
                        "${datePickercontroller.getFormattedDate(datePickercontroller.selectedStartDate.value)} - ${datePickercontroller.getFormattedDate(datePickercontroller.selectedEndDate.value)} - ${counterControllerFind.counters[1]}, ${"adult".tr}"),
                  ),
                ),
                InkWell(
                  onTap: () => Get.to(() => DatePickerScreen()),
                  child: Container(
                    width: 70,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                        child: Text(
                      'Edit'.tr,
                      style: TextStyle(color: editButtontextcolor),
                    )),
                  ),
                ),
              ],
            ),
          ),
          height20,

          //! About the property -------------------------

          Text(
            'about_the_property'.tr,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          if (abouttheproperty.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text('No Property information available'.tr),
            )
          else
            Text(abouttheproperty),
          height5,
          if (checkin.isNotEmpty && checkout.isNotEmpty)
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  decoration: BoxDecoration(
                    color: kGrey[400],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Text('${'Check-In'.tr} - $checkin'),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  decoration: BoxDecoration(
                    color: kGrey[400],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Text('${'Check-Out'.tr} - $checkout'),
                )
              ],
            ),
          height5,
          InkWell(
            onTap: aboutPropertyButton,
            child: Text(
              "view_all".tr,
              style: const TextStyle(color: kBlue),
            ),
          ),
          height10,
          HeadingText(
            heading: "Amenities".tr,
          ),

          //! Amenities List----------------------------------------
          height10,
          AmenitiesList(
            amenities: amenitiesList,
          ),
          if (amenitiesList.isNotEmpty) ...[
            height10,
            GestureDetector(
              onTap: viewAllAmenitiesOntap,
              child: Text(
                "view_all_amenities".tr,
                style: const TextStyle(color: kBlue),
              ),
            )
          ] else
            Text('No amenities available'.tr),
          height15,
          Text(
            "Map".tr,
            style: textBoldblack.copyWith(fontSize: 16),
          ),
          height10,

          //! google map--------------------------------------------
          InkWell(child: googleMap),
          height10,
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: darkRed,
              ),
              Text(
                hotelCityName,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          height20,
          //! google map end-----------------------------------------------

          //!space Image widget-------------------------------------------------
          // const HeadingText(
          //   heading: "Space Images",
          // ),
          // height10,

          // const SpaceImageWidget(),

          //NEARBY PLACE IS HIDDEN FOR NOW
          height20,
          // ! nearby place-------------------------------------------
          Text(
            "nearby_places".tr,
            style: textBoldblack.copyWith(fontSize: 16),
          ),
          height10,
          NearbyPlaceWidget(
            chaletNearbyController: chaletNearbyController,
            latLng: latLng,
          ),
          height20,
          //! Ratings page------------------------------------------------------------
          RatingsPage(
              ratings: ratings,
              avgRating: averageRating,
              numberOfRating: totalNumberOfRating,
              numberOfReview: totalNumberOfReview),

          if (int.parse(totalNumberOfReview) > 0) ...[
            height10,
            HeadingText(heading: "Top Reviews".tr),
            height15,
            Text(getRatingText(averageRating)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${"Based on".tr} ($totalNumberOfRating) ${"ratings".tr}",
                  style: const TextStyle(fontSize: 12),
                ),
                if (reviews.isNotEmpty)
                  InkWell(
                    onTap: allreviewButton,
                    child: Text(
                      "All reviews".tr,
                      style: const TextStyle(color: kBlue),
                    ),
                  ),
              ],
            ),
            height10,
          ],

          //! review widget-----------------------------------------------------------------
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: (reviews.isEmpty)
                ? const SizedBox.shrink()
                : Row(
                    children: List.generate(reviews.length, (index) {
                      DateTime dateTime = DateTime.parse(reviews[index].date);
                      DateFormat dateFormat = DateFormat('d MMMM yyyy');
                      String formattedDate = dateFormat.format(dateTime);
                      return Container(
                        width: MediaQuery.of(context).size.width / 1.4,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: kGrey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                capitalizeFirstLetter(
                                    reviews[index].reviewText),
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w200),
                                overflow: TextOverflow.visible,
                              ),
                              Text(
                                "${reviews[index].userName} - $formattedDate",
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
          ),
          height20,
//! discount offer--------------------------------------------------------------------------------------------------------
          if (offers.isNotEmpty) ...[
            HeadingText(heading: "Discount and Deals".tr),
            height5,
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                      offers.length,
                      (index) => Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: DiscountOffer(
                                promocode: offers[index].code,
                                discountPercentage:
                                    offers[index].discountPercentage.toString(),
                                discounPercentage2:
                                    offers[index].discountPercentage.toString(),
                                discountCondition: offers[index].description!),
                          )),
                )),
          ],

          height15,
          //! property list card -------------------------------------------------------------------------------------------
          chaletCheck == 'CHALET'
              ? PropertyRulesCardChalet(chaletId: hotelId)
              : PropertyRulesCard(
                  hotelId: hotelId,
                )
        ],
      ),
    );
  }
}
