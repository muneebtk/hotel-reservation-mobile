import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/constant/images/demo.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:e_concierge_tourism/controller/api/hotel_booking/hotel_detail/hotel_detail.dart';
import 'package:e_concierge_tourism/getx/date_picker_controller.dart';
import 'package:e_concierge_tourism/view/chalets_booking/chalet_list/widget/like_button.dart';
import 'package:e_concierge_tourism/view/chalets_booking/review_booking_page/review_booking_page.dart';
import 'package:e_concierge_tourism/view/hotel_booking/hotel_detail/widgets/all_images_of_hotel.dart';
import 'package:e_concierge_tourism/getx/hotel_detail_controller.dart';
import 'package:e_concierge_tourism/view/hotel_booking/hotel_detail/widgets/amenities_list.dart';
import 'package:e_concierge_tourism/common/chat/chat_page.dart';
import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import 'package:e_concierge_tourism/common/star_ratings/rating_widget.dart';
import 'package:e_concierge_tourism/view/hotel_booking/hotel_detail/widgets/review_all.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controller/api/chalets_booking/chalet_list_and_detail/chalet_search_api.dart';
import '../../../common/bottom_nav_buttom_property_details_page/bottom_buttom_hoteldetails_page.dart';
import '../../../common/ui_property_details_page_widget/hotel_detail_ui_widget.dart';
import '../../../constant/styles/colors.dart';
import '../../../getx/count_of_guest.dart';
import '../../hotel_booking/hotel_detail/widgets/about_the_property.dart';
import 'package:http/http.dart' as http;

class ChaletsDetail extends StatefulWidget {
  final int id;
  final Function(bool)? favouriteStatusChange;
  final int? promoId;
  final String cityName;

  const ChaletsDetail({
    super.key,
    required this.id,
    this.favouriteStatusChange,
    this.promoId,
    required this.cityName,
  });

  @override
  State<ChaletsDetail> createState() => _ChaletsDetailState();
}

class _ChaletsDetailState extends State<ChaletsDetail> {
  final ChaletSearchApi chalestDetailController = Get.put(ChaletSearchApi());

  //google map widget (location for chalet)

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

  final DatePickerController datePickercontroller = Get.find();
  final ChaletDetailController controller = Get.put(ChaletDetailController());
  @override
  void initState() {
    final checkinDate = DateFormat('yyyy-MM-dd')
        .format(datePickercontroller.selectedStartDate.value);
    final checkoutDate = DateFormat('yyyy-MM-dd')
        .format(datePickercontroller.selectedEndDate.value);
    chalestDetailController.fetchChaletDetail(
        widget.id, checkinDate, checkoutDate, widget.cityName);
    super.initState();
  }

  void shareButton(String chaletID, String price, String imageUrl) async {
    final link = "$baseUrl/chalet/details/$chaletID?city=${widget.cityName}";

    try {
      // Download the image
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // Get the temporary directory of the device
        final tempDir = await getTemporaryDirectory();
        final imagePath = '${tempDir.path}/chalet_image.jpg';
        final file = File(imagePath);

        // Write the image bytes to the file
        await file.writeAsBytes(response.bodyBytes);

        // Share the image and the link
        await Share.shareXFiles(
          [XFile(imagePath)],
          text: "Check out this awesome property on 1929 Way: $link",
        );
      } else {
        await Share.share('Check out this awesome property on 1929 Way: $link');
        // print("Failed to download image: ${response.statusCode}");
      }
    } catch (e) {
      await Share.share('Check out this awesome property on 1929 Way: $link');
      // print("Failed to share: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(CounterController());
    Get.put(HotelDetailsControllerApi());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chalet details'.tr,
          style: textBoldblack.copyWith(fontSize: 18),
        ),
        actions: [
          Obx(() {
            final data = chalestDetailController.chaletListDetail;
            return chalestDetailController.chaletListDetail.isNotEmpty &&
                    !chalestDetailController.loading.value
                ? Row(
                    children: [
                      InkWell(
                        //deeeplink
                        onTap: () {
                          final price = chalestDetailController
                              .chaletListDetail[0].pricePerNight;
                          final image = chalestDetailController
                                  .chaletListDetail[0].mainImage ??
                              '';
                          shareButton(
                              widget.id.toString(), '${price ?? ''}', image);
                        },
                        child: const Icon(Icons.share),
                      ),
                      width10,
                      LikeButtonChalet(
                          onchange: (newValue) {
                            data.first.isFavorite = newValue;
                            if (widget.favouriteStatusChange != null) {
                              widget.favouriteStatusChange!(newValue);
                            }
                          },
                          isFavorite: data.first.isFavorite,
                          chaletHotelNameController: data.first.name.toString(),
                          address: data.first.cityName.toString(),
                          hotelId: data.first.id ?? 0),
                      width10
                    ],
                  )
                : const SizedBox.shrink();
          }),
          width10,
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final width = constraints.maxWidth;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: height * 0.30,
                      width: width,
                      child: Obx(() {
                        if (chalestDetailController.loading.value) {
                          // Show shimmer while loading
                          return PageView.builder(
                            itemCount: 3,
                            onPageChanged: controller.updatePage,
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(255, 218, 216, 216),
                                highlightColor: Colors.grey,
                                child: Container(
                                  color: kGrey,
                                ),
                              );
                            },
                          );
                        } else if (chalestDetailController
                                .chaletListDetail.isEmpty ||
                            chalestDetailController
                                .chaletListDetail[0].chaletImages!.isEmpty) {
                          // Display a message if no images are available
                          return Center(child: Text('no_image'.tr));
                        } else {
                          // Display images when data is available
                          return PageView.builder(
                            itemCount: chalestDetailController
                                .chaletListDetail[0].chaletImages!.length,
                            onPageChanged: controller.updatePage,
                            itemBuilder: (context, index) {
                              return CachedNetworkImage(
                                imageUrl: chalestDetailController
                                    .chaletListDetail[0]
                                    .chaletImages![index]
                                    .imageUrl
                                    .toString(),
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Center(child: Image.network(loadingImage)),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              );
                            },
                          );
                        }
                      }),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 15,
                      //all image showing page (navigting)
                      child: GestureDetector(
                        onTap: () => Get.to(() => AllImagesChalet()),
                        child: const Chip(
                          label: Text("5"),
                          avatar: Icon(Icons.camera_alt),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -17,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 25,
                      left: width / 2 - 40,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: lightgrey,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: List.generate(
                              3,
                              (index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                child: Obx(() => Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: index ==
                                                controller.currentPage.value
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

                //!chalet details---------------

                Obx(() {
                  String limitText(String text, int wordLimit) {
                    List<String> words = text.split(' ');
                    if (words.length <= wordLimit) return text;
                    return '${words.sublist(0, wordLimit).join(' ')}...';
                  }

                  if (chalestDetailController.loading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (chalestDetailController.chaletListDetail.isEmpty) {
                    return const Center(
                        child: Text('No chalet details available.'));
                  }
                  final data = chalestDetailController.chaletListDetail[0];

                  //amenities

                  List<AmenityS> staticAmenities = List.generate(
                      chalestDetailController
                          .chaletListDetail[0].amenities!.length, (index) {
                    final datas = chalestDetailController
                        .chaletListDetail[0].amenities![index];
                    return AmenityS(
                        datas.icon.toString(), datas.name.toString());
                  });

                  //chalet ui widget (dont be confused by HotelUI, i used hotelUI widget for both)
                  return HotelUi(
                    checkin: data.checkinTime?.format(context) ?? '',
                    checkout: data.checkoutTime?.format(context) ?? '',
                    latLng: LatLng(data.lat!, data.lng!),
                    offers: data.offers ?? [],
                    chaletCheck: 'CHALET',
                    reviews: data.reviewData != null
                        ? data.reviewData!.reviews!
                        : [],

                    totalNumberOfReview:
                        data.reviewData?.numberOfReviews.toString() ?? '',
                    totalNumberOfRating:
                        data.reviewData?.numberOfRatings.toString() ?? '',
                    aboutPropertyButton: () {
                      Get.to(() => AboutThePropertyChalet(
                            amenityText: data.amenities![0].name,
                            icon: data.amenities![0].icon,
                            text: data.aboutProperty.toString(),
                            hotelid: widget.id.toString(),
                            contactNumber: data.officeNumber ?? '',
                          ));
                    },
                    hotelId: "1",
                    allreviewButton: () {
                      Get.to(() => ReviewAllPageDetail(
                            ratings: [
                              data.reviewData?.numbersOfTotal5Star ?? 0,
                              data.reviewData?.numbersOfTotal4Star ?? 0,
                              data.reviewData?.numbersOfTotal3Star ?? 0,
                              data.reviewData?.numbersOfTotal2Star ?? 0,
                              data.reviewData?.numbersOfTotal1Star ?? 0,
                            ],
                            reviews: data.reviewData?.reviews ?? [],
                            totalNumberOfReview:
                                data.reviewData?.numberOfReviews.toString() ??
                                    '',
                            totalNumberOfRating:
                                data.reviewData?.numberOfRatings.toString() ??
                                    '',
                            averageRating: data.reviewData?.avgRating ?? 5,
                          ));
                    },
                    viewAllAmenitiesOntap: () {
                      Get.to(() => AboutThePropertyChalet(
                            amenityText: data.amenities![0].name,
                            icon: data.amenities![0].icon,
                            text: data.aboutProperty.toString(),
                            hotelid: widget.id.toString(),
                            contactNumber: data.officeNumber ?? '',
                          ));
                    },

                    //amenities
                    amenitiesList: staticAmenities,

                    abouttheproperty:
                        limitText(data.aboutProperty.toString(), 40),
                    hotelCityName: data.cityName.toString(),

                    //chat screeen

                    ontap: () {
                      Get.to(() => ChatScreen());
                    },
                    ratings: [
                      data.reviewData?.numbersOfTotal5Star ?? 0,
                      data.reviewData?.numbersOfTotal4Star ?? 0,
                      data.reviewData?.numbersOfTotal3Star ?? 0,
                      data.reviewData?.numbersOfTotal2Star ?? 0,
                      data.reviewData?.numbersOfTotal1Star ?? 0,
                    ],
                    reviewScore1:
                        "${data.reviewData?.avgRating ?? 5} ${"review_Score".tr} ",
                    reviewScore2:
                        "${data.reviewData?.numberOfRatings ?? 0} ${"Reviews".tr}",
                    rating: Wrap(
                      runSpacing: 5,
                      spacing: 10,
                      children: [
                        if (data.propertyType?.icon != null &&
                            data.propertyType?.type != null)
                          Row(
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
                    averageRating:
                        data.reviewData?.avgRating?.toDouble() ?? 0.0,
                    editButtontextcolor: kWhite,
                    color: darkRed,
                    hotelName: data.name.toString().toUpperCase(),

                    //goggle map
                    googleMap: checkLatLng(LatLng(data.lat!, data.lng!))
                        ? SizedBox(
                            height: 150,
                            child: GoogleMap(
                              mapType: MapType.normal,
                              // liteModeEnabled: true,
                              buildingsEnabled: true,
                              indoorViewEnabled: true,
                              onTap: (argument) {
                                launchGoogleMaps(LatLng(data.lat!, data.lng!));
                              },
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(data.lat!, data.lng!),
                                  zoom: 13.0),
                              markers: {
                                Marker(
                                  markerId: const MarkerId("city_name"),
                                  icon: BitmapDescriptor.defaultMarker,
                                  position: LatLng(data.lat!, data.lng!),
                                ),
                              },
                              onMapCreated: (GoogleMapController controller) {},
                            ),
                          )
                        : const SizedBox.shrink(),
                  );
                }),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Obx(() {
        if (chalestDetailController.loading.value ||
            chalestDetailController.chaletListDetail.isEmpty) {
          return const SizedBox.shrink();
        } else {
          final price =
              chalestDetailController.chaletListDetail[0].pricePerNight;
          return BottomButtomHotelDetailsPage(
            buttonname: 'Book Chalet'.tr,
            price: price != null ? "$price ${"OMR + Tax".tr}" : "",
            ontap: chalestDetailController.chaletListDetail.isNotEmpty
                ? () => Get.to(() => ChaletReviewBookingPage(
                      chaletId: widget.id,
                      chaletImage: "",
                      promoId: widget.promoId,
                    ))
                : () {},
          );
        }
      }),
    );
  }

  bool checkLatLng(LatLng latLng) {
    if (latLng.latitude > 0 && latLng.longitude > 0) {
      return true;
    }
    return false;
  }
}
