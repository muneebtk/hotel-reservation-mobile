import 'dart:io';

import 'package:e_concierge_tourism/common/compare_properties/compare_properties.dart';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/controller/api/chalets_booking/chalet_list_and_detail/chalet_search_api.dart';
import 'package:e_concierge_tourism/controller/api/hotel_booking/filter_hotels/filter.dart';
import 'package:e_concierge_tourism/getx/adding_favourite.dart';
import 'package:e_concierge_tourism/getx/count_of_guest.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:e_concierge_tourism/view/bottom_nav.dart/bottom_nav.dart';
import 'package:e_concierge_tourism/view/chalets_booking/chalet_detail/chalet_detail.dart';
import 'package:e_concierge_tourism/view/chalets_booking/chalet_list/widget/included.dart';
import 'package:e_concierge_tourism/getx/date_picker_controller.dart';
import 'package:e_concierge_tourism/view/chalets_booking/chalet_list/widget/like_button.dart';
import 'package:e_concierge_tourism/view/hotel_booking/hotel_list/widgets/compare_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/button/button.dart';
import '../../../constant/styles/sizedbox.dart';
import '../../../constant/styles/textstyle.dart';
import '../../../controller/api/hotel_booking/filter_hotels/sort.dart';
import '../../../controller/model/chalet_bookings/chalet_booking_entire/chalet_searching.dart';
import '../../../language/controller/categorie_name_trans.dart';
import '../../../controller/service/compare_hotels/favourites_list.dart';
import '../../hotel_booking/components/app_bar.dart';
import '../../hotel_booking/search_hotels/widgets/date_picker_screen.dart';
import '../../my_bookings/cancelled/cancelled.dart';
import '../components/chalet_list.dart';
import 'package:http/http.dart' as http;

class ChaletListPage extends StatefulWidget {
  const ChaletListPage({super.key, required this.city, required this.cityLatLng});
  final String city;
  final LatLng? cityLatLng;

  @override
  State<ChaletListPage> createState() => _ChaletListPageState();
}

class _ChaletListPageState extends State<ChaletListPage> {
  //**---------------------------------------------------------------------------

  AddingCompare addingCompareController = Get.put(AddingCompare());

  CompareApiController addCompareController = Get.put(CompareApiController());

  final DatePickerController datePickercontroller = Get.find();

  final ChaletHotelNameController chaletHotelNameController = Get.find();

  final ChaletSearchApi chalestListController = Get.put(ChaletSearchApi());
  final CounterController counterControllerFind = Get.find();

  //*-----------------------------------------------------------------------------
  final SortByControllerChalet sortcontroller =
      Get.put(SortByControllerChalet());

  FilterControllerCHALET filterController = Get.put(FilterControllerCHALET());

  final DatePickerController datePickerController = Get.find();
  @override
  void initState() {
    super.initState();
  }

  void shareButton(
      String chaletID, String price, String imageUrl, String cityName) async {
    final link = "$baseUrl/chalet/details/$chaletID?city=$cityName";

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
          subject: "Awesome Property!",
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
    Get.put(FavouritesService());
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Obx(
          () => Appbar(
            onTap: () => Get.to(() => DatePickerScreen()),
            titleOnTap: () {
              Get.back();
            },
            adults: "",
            subtitle:
                "${datePickercontroller.getFormattedDate(datePickercontroller.selectedStartDate.value)} - ${datePickercontroller.getFormattedDate(datePickercontroller.selectedEndDate.value)}",
            trailingTitle: "Edit".tr,
            icon: Icons.rate_review,
            title: chalestListController.chaletList.isEmpty
                ? "No Chalet"
                : widget.city,
            onTapCompare: PopupMenuButton(
              color: kWhite,
              onSelected: (value) {
                if (value == 'compare') {
                  Get.to(
                    () => ComparePageScreeenHotel(
                      type: 'chalet',
                      update: (id) {
                        for (var element in chalestListController.chaletList) {
                          if (element.chaletID == id) {
                            element.isAdded = !element.isAdded;
                            setState(() {});
                            break;
                          }
                        }
                      },
                    ),
                  );
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'compare',
                  child: Text('Compare Chalets'.tr),
                ),
              ],
              icon: const Icon(Icons.more_vert),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            height10,
            SizedBox(
                height: 50,
                child: Obx(() => ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: chaletHotelNameController
                              .chaletIncludedOptions.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: () async {
                                  index == 0
                                      ? sortmethod(
                                          context, height, sortcontroller)
                                      : filterOption(context);

                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  pref.setString(
                                      'city',
                                      chalestListController
                                          .chaletList[0].cityName);
                                },
                                child: ChaletsIncludedOptions(
                                    icon: Icons.keyboard_arrow_down,
                                    includedNames: chaletHotelNameController
                                        .chaletIncludedOptions[index].tr),
                              ),
                            );
                          },
                        )
                    // const SizedBox(),
                    )),
            height15,
            chalestListController.chaletList.isNotEmpty
                ? Text(
                    "${chalestListController.chaletList.length} ${"properties found in ".tr} ${widget.city.isNotEmpty ? widget.city : ''}"
                        .tr
                        .tr,
                    style: const TextStyle(color: kGrey),
                  )
                : const SizedBox(),
            height10,
            Expanded(
              child: Obx(() {
                if (chalestListController.chaletList.isEmpty) {
                  return Center(
                      child: Column(
                    //if there is no chalet
                    children: [
                      height50,
                      Image.network(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQl80JIBn4W75mIXSonrFCud2_aviz0UIj3KQ&s"),
                      height30,
                      const Text(
                        "No Chalet Available for this City!",
                        style: TextStyle(fontSize: 12, color: kGrey),
                      )
                    ],
                  ));
                }

                //chalet listing
                return ListView.builder(
                    itemCount: chalestListController.chaletList.length,
                    itemBuilder: (context, index) {
                      final data = chalestListController.chaletList[index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        //! chalet list-----------------------------------------
                        child: ChaletsList(
                          propertyType: data.chaletType,
                          discountedPrice:
                              data.bestOffersCommon?.discountedPrice ?? 0,
                          //deeeplinking-----(sharing chalet to social media)
                          shareButton: () {
                            shareButton(
                              data.chaletID.toString(),
                              data.price.toString(),
                              data.image
                                  .toString(), // Make sure this is the correct image URL
                              data.cityName,
                            );
                          },

                          // shareButton: () {
                          //   final link =
                          //       "http://hotels.1929way.app/details?chaletID=${data.chaletID}&chaletPRICE=${data.price.toString()}";
                          //   Share.share(link);
                          // },
                          discountPercentage:
                              data.bestOffersCommon?.discountPercentage ?? '',
                          rating:
                              '${data.rating?.toStringAsFixed(1)} ${getRatingText(data.rating ?? 0)}',
                          rating2: ' (${data.reviewCount} ${"ratings".tr}) ',
                          price: data.price ?? 0,
                          tax: "OMR".tr,
                          hotelImage: chalestListController.loading.value
                              ? "https://i.sstatic.net/y9DpT.jpg"
                              : data.image.toString(),
                          hotelName: data.name.toString(),
                          address: data.cityName.toString(),
                          likeButton: LikeButtonChalet(
                              onchange: (newValue) {
                                data.isFavorite = newValue;
                              },
                              isFavorite: data.isFavorite,
                              chaletHotelNameController: data.name.toString(),
                              address: data.cityName.toString(),
                              hotelId: data.chaletID!),

                          //! Chalet details page navigating-------------------------

                          ontap: () {
                            Get.to(() => ChaletsDetail(
                                  cityName: data.cityName,
                                  favouriteStatusChange: (newValue) {
                                    data.isFavorite = newValue;
                                    chalestListController.chaletList[index] =
                                        data;
                                  },
                                  id: data.chaletID!,
                                  promoId: data.bestOffersCommon?.id,
                                ));
                          },
                          trailing: Obx(() {
                            return CompareButton(
                                icon: data.isAdded
                                    ? const Icon(Icons.done)
                                    : const Icon(Icons.add),
                                text: data.isAdded
                                    ? Text(
                                        "Added".tr,
                                        style: textColorblack.copyWith(
                                            fontSize: 12),
                                      )
                                    : Text(
                                        "Compare".tr,
                                        style: textColorblack.copyWith(
                                            fontSize: 12),
                                      ),
                                //adding comapre------
                                ontap: addCompareController.loading.value
                                    ? null
                                    : () async {
                                        final isGuest =
                                            await guestCheckingBooking();
                                        if (isGuest) {
                                          loginPrompt(isBooking: false);
                                          return;
                                        }
                                        if (data.isAdded) {
                                          data.isAdded = false;
                                          final success =
                                              await addCompareController
                                                  .removeFromList(
                                                      data.chaletID!, 'chalet');
                                          if (!success) {
                                            data.isAdded = true;
                                          }
                                        } else {
                                          data.isAdded = true;
                                          final success =
                                              await addCompareController
                                                  .addProperty(
                                                      data.chaletID!, 'chalet');
                                          if (!success) {
                                            data.isAdded = false;
                                          }
                                        }
                                      });
                          }),
                        ),
                      );
                    });
              }),
            )
          ],
        ),
      ),
    );
  }

  //! sort method--------------------------------------------------------------------------------------
  Future<dynamic> sortmethod(BuildContext context, double height,
      SortByControllerChalet sortcontroller) {
    return showModalBottomSheet(
      backgroundColor: kWhite,
      enableDrag: true,
      context: context,
      builder: (context) {
        return SizedBox(
          height: height / 2,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sort by".tr,
                  style: textBoldblack,
                ),
                height5,
                Expanded(
                  child: ListView.builder(
                    itemCount: sortcontroller.sortListNames.length,
                    itemBuilder: (context, index) => Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          color: sortcontroller.selectedIndex.value == index
                              ? Colors.red.shade100
                              : Colors.transparent,
                        ),
                        child: ListTile(
                          trailing: sortcontroller.selectedIndex.value == index
                              ? const Icon(
                                  Icons.done,
                                  color: Colors.red,
                                )
                              : null,
                          onTap: () {
                            sortcontroller.updateIndex(index);
                          },
                          title: Text(sortcontroller.sortListNames[index]),
                          leading: Icon(
                            sortcontroller.sortListIcons[index],
                            color: sortcontroller.selectedIndex.value == index
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonWidget(
                      ontap: () async {
                        final adults = counterControllerFind.counters[1];
                        final children = counterControllerFind.counters[2];
                        final members = adults + children;
                        controller.loading.value = true;
                        String selectedSort = sortcontroller.getSelectedSort();

                        ChaletSearchRequestModel model1 =
                            ChaletSearchRequestModel(
                              lat: widget.cityLatLng?.latitude,
                              lng: widget.cityLatLng?.longitude,
                          amenities: [],
                          sorted: selectedSort == "Recommeded".tr
                              ? 'recommeded'
                              : selectedSort == 'Lowest Price'.tr
                                  ? 'lowest_price'
                                  : selectedSort == 'Highest Price'.tr
                                      ? 'highest_price'
                                      : 'chalet_star_rating',
                          rating: 0,
                          members: members.toString(),
                          // filter: {
                          //   "price": [],
                          //   "location": [],
                          // },
                          cityName: widget.city,
                          checkinDate:
                              datePickerController.getFormattedDateReverse(
                                  datePickerController.selectedStartDate.value),
                          checkoutDate:
                              datePickerController.getFormattedDateReverse(
                                  datePickerController.selectedEndDate.value),
                        );
                        bool success =
                            await chalestListController.fetchChalets(model1);
                        if (success) {
                          controller.loading.value = false;
                          Get.back();
                          setState(() {});
                        }
                      },
                      text: Obx(
                        () => controller.loading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: kWhite,
                                ),
                              )
                            : Text(
                                'Submit'.tr,
                                style: textColorwhite,
                              ),
                      )),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  //!filter ------------------------------------------

  Future<dynamic> filterOption(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: kWhite,
      enableDrag: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Filter by".tr,
                    style: textBoldblack,
                  ),
                  height5,
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        buildFilterSection(
                          "Guest Rating".tr,
                          [
                            "4.0+ Excellent".tr,
                            "3.0+ Very good".tr,
                            "2.0+ Good".tr,
                            "1.0 Fair".tr
                          ],
                          filterController.guestRatings,
                          filterController.toggleGuestRating,
                        ),
                        buildFilterSection(
                          "Property Amenity".tr,
                          chalestListController.allAmanities
                              .map((amenity) => '$amenity')
                              .toList(),
                          // [
                          //   "Gym".tr,
                          //   "Free Wifi".tr,
                          //   "Swimming pool".tr,
                          //   "ac",
                          //   "pool"
                          // ],
                          filterController.propertyAmenities,
                          filterController.togglePropertyAmenity,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonWidget(
                        ontap: () async {
                          final adults = counterControllerFind.counters[1];
                          final children = counterControllerFind.counters[2];
                          final members = adults + children;
                          controller.loading.value = false;
                          final selectedFilters =
                              filterController.getSelectedFilters();
                          // final selectedFiltersChalet = filterController
                          //     .getSelectedFiltersHighestRating();
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          ChaletSearchRequestModel model1 =
                              ChaletSearchRequestModel(
                            amenities: selectedFilters,
                            sorted: 'lowest_price',
                            rating: 0,
                            members: members.toString(),
                            // filter: selectedFilters,
                            cityName: widget.city,
                            lat: widget.cityLatLng?.latitude,
                            lng: widget.cityLatLng?.longitude,
                            checkinDate: datePickerController
                                .getFormattedDateReverse(datePickerController
                                    .selectedStartDate.value),
                            checkoutDate:
                                datePickerController.getFormattedDateReverse(
                                    datePickerController.selectedEndDate.value),
                          );

                          bool success =
                              await chalestListController.fetchChalets(model1);
                          if (success) {
                            controller.loading.value = false;
                            Get.back();
                            await chalestListController.fetchChalets(model1);
                            setState(() {});
                          }
                        },
                        text: Obx(
                          () => controller.loading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: kWhite,
                                  ),
                                )
                              : Text(
                                  'Apply'.tr,
                                  style: textColorwhite,
                                ),
                        )),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildFilterSection(String title, List<String> options,
      RxList<bool> values, Function(int) onChanged) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textBoldblack,
          ),
          height5,
          Column(
            children: List.generate(options.length, (index) {
              return Obx(
                () => SizedBox(
                  height: 40,
                  child: CheckboxListTile(
                    title: Text(options[index]),
                    value: values[index],
                    onChanged: (bool? value) {
                      onChanged(index);
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.red,
                  ),
                ),
              );
            }),
          ),
          height10,
        ],
      ),
    );
  }
}
