import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_concierge_tourism/constant/images/demo.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:e_concierge_tourism/controller/api/hotel_booking/hotel_detail/hotel_detail.dart';
import 'package:e_concierge_tourism/getx/count_of_guest.dart';
import 'package:e_concierge_tourism/getx/date_picker_controller.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:e_concierge_tourism/view/hotel_booking/hotel_detail/widgets/about_the_property.dart';
import 'package:e_concierge_tourism/view/hotel_booking/hotel_detail/widgets/amenities_list.dart';
import 'package:e_concierge_tourism/view/hotel_booking/hotel_detail/widgets/review_all.dart';
import 'package:e_concierge_tourism/view/hotel_booking/hotel_list/hotel_ilst.dart';
import 'package:e_concierge_tourism/view/hotel_booking/hotel_list/widgets/like_button_hotel.dart';
import 'package:e_concierge_tourism/view/hotel_booking/room_selection/room_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../getx/searching_hotel_name.dart';
import '../../../common/bottom_nav_buttom_property_details_page/bottom_buttom_hoteldetails_page.dart';
import '../../../common/chat/chat_page.dart';
import '../../../common/ui_property_details_page_widget/hotel_detail_ui_widget.dart';
import '../../../controller/api/hotel_booking/hotel_search/search_hotel_controller.dart';
import '../../../getx/hotel_detail_controller.dart';
import 'widgets/all_images_of_hotel.dart';

class HotelDetail extends StatefulWidget {
  final Function(bool)? favouriteStatusChange;
  final int hotelId;
  final int? promoId;

  const HotelDetail({
    super.key,
    this.favouriteStatusChange,
    required this.hotelId,
    this.promoId,
  });

  @override
  State<HotelDetail> createState() => _HotelDetailState();
}

class _HotelDetailState extends State<HotelDetail> {
  final ss = Get.put(SearchingHotelName());
  final SearchingHotelName searchController = Get.find();
  final DatePickerController datePickercontroller = Get.find();
  final HotelDetailController _controller = Get.put(HotelDetailController());
  final HotelDetailsControllerApi apiController =
      Get.put(HotelDetailsControllerApi());
  final sss = Get.put(SearchHotelCityNameController());
  final SearchHotelCityNameController controller = Get.find();
  final CounterController counterControllerFind = Get.find();

  @override
  void initState() {
    final checkinDate = DateFormat('yyyy-MM-dd')
        .format(datePickercontroller.selectedStartDate.value);
    final checkoutDate = DateFormat('yyyy-MM-dd')
        .format(datePickercontroller.selectedEndDate.value);
    final members =
        counterControllerFind.counters[1] + counterControllerFind.counters[2];
    final rooms = counterControllerFind.counters[0];
    apiController.fetchHotelDetail(
        widget.hotelId.toString(), checkinDate, checkoutDate, members, rooms);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(CounterController());

    //google map widget
    Future<void> launchGoogleMaps(LatLng location) async {
      final Uri url = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}');
      final Uri appleMapsUrl = Uri.parse(
          'http://maps.apple.com/?q=${location.latitude},${location.longitude}');

      if (GetPlatform.isAndroid) {
        await canLaunchUrl(url);
      } else {
        await launchUrl(appleMapsUrl);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "hotel_detail".tr,
          style: textBoldblack.copyWith(fontSize: 18),
        ),
        actions: [
          // if (widget.favouriteCode == 1)
          Obx(() {
            var hotel = apiController.hotelDetails.value;
            return apiController.loading.value ||
                    apiController.hotelDetails.value.name.isEmpty
                ? const SizedBox.shrink()
                : Row(
                    children: [
                      InkWell(
                          //deeeplink
                          onTap: () {
                            shareButton(widget.hotelId.toString(),
                                apiController.hotelDetails.value.hotelImage);
                          },
                          child: const Icon(Icons.share)),
                      width10,
                      LikeButton(
                          onchange: (newValue) {
                            hotel.isFavorite = newValue;
                            if (widget.favouriteStatusChange != null) {
                              widget.favouriteStatusChange!(newValue);
                            }
                          },
                          isFavorite: hotel.isFavorite,
                          chaletHotelNameController: hotel.name,
                          address: hotel.address,
                          hotelId: widget.hotelId),
                    ],
                  );
          }),
          width10,
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Obx(() {
                    //loading time this widget will show
                    if (apiController.loading.value) {
                      return PageView.builder(
                        itemCount: 3,
                        onPageChanged: _controller.updatePage,
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: const Color.fromARGB(255, 218, 216, 216),
                            highlightColor: Colors.grey,
                            child: Container(
                              color: kGrey,
                            ),
                          );
                        },
                      );
                    } else if (apiController
                        .hotelDetails.value.hotelImage.isEmpty) {
                      return Center(child: Text('no_image'.tr));
                    }
                    return PageView.builder(
                      itemCount: 3,
                      onPageChanged: _controller.updatePage,
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: apiController.hotelDetails.value.hotelImage[
                              index %
                                  apiController
                                      .hotelDetails.value.hotelImage.length],
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
                    );
                  }),
                ),
                //more image
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Obx(
                    () => GestureDetector(
                      onTap: () => Get.to(() => AllImagesHotels(
                          images: apiController.hotelDetails.value.hotelImage)),
                      child: Chip(
                        label: Text(apiController
                            .hotelDetails.value.hotelImage.length
                            .toString()),
                        avatar: const Icon(Icons.camera_alt),
                      ),
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
                                    color:
                                        index == _controller.currentPage.value
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
            //!Hotel UI widget----------------------------------------------------------
            //*========================================================================================================
            Obx(() {
              if (apiController.loading.value) {
                return const Center(
                    child: Column(
                  children: [
                    height50,
                    CircularProgressIndicator(
                      color: darkRed,
                    )
                  ],
                ));
              }

              if (apiController.hotelDetails.value.amenities.isEmpty) {
                return Center(
                  child: Text('Something went wrong'.tr),
                );
              }

              //hotel amenities

              List<AmenityS> staticAmenities = List.generate(
                  apiController.hotelDetails.value.amenities.length, (index) {
                final data = apiController.hotelDetails.value.amenities[index];

                return AmenityS(data.icon, data.name);
              });

              final data = apiController.hotelDetails.value;
              //hotel detail widget

              return HotelUi(
                latLng: LatLng(data.lat, data.lng),
                hotelId: widget.hotelId.toString(),
                hotelName: data.name[0].toUpperCase() + data.name.substring(1),
                hotelCityName: data.cityName.toUpperCase(),
                checkin: data.checkin?.format(context) ?? '',
                checkout: data.checkout?.format(context) ?? '',
                abouttheproperty: data.aboutProperty,
                amenitiesList: staticAmenities,
                offers: apiController.hotelDetails.value.offers,
                viewAllAmenitiesOntap: () {
                  Get.to(() => AboutTheProperty(
                        contactNumber: data.officeNumber,
                        text: data.aboutProperty,
                        hotelid: widget.hotelId.toString(),
                      ));
                },
                aboutPropertyButton: () {
                  Get.to(() => AboutTheProperty(
                        contactNumber: data.officeNumber,
                        text: data.aboutProperty,
                        hotelid: widget.hotelId.toString(),
                      ));
                },

                //*---------------review section---------------------------------------

                reviewScore1: "${data.avgrating} ${"review_Score".tr} ",
                reviewScore2: "${data.numberRating} ${"Reviews".tr}",
                rating: Wrap(
                  runSpacing: 5,
                  spacing: 10,
                  children: [
                    if (data.hotelRating.isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CachedNetworkImage(
                            imageUrl: getPropertyStarIcon(data.hotelRating),
                            width: 20,
                            height: 20,
                          ),
                          width5,
                          Flexible(
                            child: Text(
                              showPropertyStarText(data.hotelRating),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (data.propertyType?.icon != null &&
                        data.propertyType?.type != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CachedNetworkImage(
                            width: 20,
                            height: 20,
                            imageUrl: data.propertyType!.icon!,
                            errorWidget: (context, url, error) =>
                                const SizedBox.shrink(),
                          ),
                          // Image.network(
                          //   data.propertyType!.icon!,
                          //   width: 20,
                          //   height: 20,
                          // ),
                          width5,
                          Flexible(
                            child: Text(
                              data.propertyType!.type!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          width10,
                        ],
                      ),
                  ],
                ),
                // RatingWidget(rating: double.parse(data.hotelRating)),
                averageRating: data.avgrating,
                totalNumberOfReview: data.numberReview.toString(),
                totalNumberOfRating: data.numberRating.toString(),
                reviews: data.reviews,
                ratings: [
                  data.total5star,
                  data.total4star,
                  data.total3star,
                  data.total2star,
                  data.total1star
                ],
                //-------buttons  ------------------------------------------

                allreviewButton: () => Get.to(() => ReviewAllPageDetail(
                      ratings: [
                        data.total5star,
                        data.total4star,
                        data.total3star,
                        data.total2star,
                        data.total1star
                      ],
                      reviews: data.reviews,
                      totalNumberOfReview: data.numberReview.toString(),
                      totalNumberOfRating: data.numberRating.toString(),
                      averageRating: data.avgrating,
                    )),
                ontap: () {
                  Get.to(() => ChatScreen());
                },

                //*-----------edit button colors---------------------------

                editButtontextcolor: kBlack,
                color: Colors.orange,

                //*google map-------------------

                googleMap: Obx(
                  () {
                    double latitude = apiController.hotelDetails.value.lat;
                    double longitude = apiController.hotelDetails.value.lng;

                    if (latitude <= 0 && longitude <= 0) {
                      return const SizedBox.shrink();
                    }

                    LatLng googlePlex = LatLng(latitude, longitude);
                    return SizedBox(
                      height: 150,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        // liteModeEnabled: true,
                        buildingsEnabled: true,
                        indoorViewEnabled: true,
                        onTap: (argument) {
                          launchGoogleMaps(googlePlex);
                        },
                        initialCameraPosition:
                            CameraPosition(target: googlePlex, zoom: 13.0),
                        markers: {
                          Marker(
                            markerId: const MarkerId("city_name"),
                            icon: BitmapDescriptor.defaultMarker,
                            position: googlePlex,
                          ),
                        },
                        onMapCreated: (GoogleMapController controller) {},
                      ),
                    );
                  },
                ),
              );
            }),
            //*========================================================================================================

            //! hotel UI completed-----------------------------------------------------------
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        if (apiController.loading.value ||
            apiController.hotelDetails.value.name.isEmpty) {
          return const SizedBox.shrink();
        } else {
          final price = apiController.hotelDetails.value.price;
          return BottomButtomHotelDetailsPage(
              buttonname: "continue".tr,
              price: price > 0 ? "$price OMR + Tax".tr : '',
              ontap: apiController.hotelDetails.value.name.isNotEmpty
                  ? () async {
                      if (datePickercontroller.selectedStartDate.value
                          .isAtSameMomentAs(
                              datePickercontroller.selectedEndDate.value)) {
                        Get.snackbar(
                          'Failed'.tr,
                          'Date should not be same date',
                        );
                        return;
                      } else {
                        Get.to(() => RoomSelection(
                              countryTax:
                                  apiController.hotelDetails.value.countryTax,
                              hotelId: widget.hotelId,
                              hotelImage: apiController
                                  .hotelDetails.value.hotelImage[0],
                              hotelname: apiController.hotelDetails.value.name,
                              promoId: widget.promoId,
                            ));
                      }
                    }
                  : () {});
        }
      }),
    );
  }
}
