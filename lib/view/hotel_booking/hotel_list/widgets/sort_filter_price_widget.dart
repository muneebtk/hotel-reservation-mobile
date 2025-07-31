import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/search_hotels_model.dart';
import 'package:e_concierge_tourism/common/button/button.dart';
import 'package:e_concierge_tourism/getx/searching_hotel_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../controller/api/hotel_booking/filter_hotels/filter.dart';
import '../../../../controller/api/hotel_booking/filter_hotels/price_sort.dart';
import '../../../../controller/api/hotel_booking/filter_hotels/sort.dart';
import '../../../../controller/api/hotel_booking/hotel_search/search_hotel_controller.dart';
import '../../../../getx/checkedbox.dart';
import 'sort_filter_price.dart';

class SortFilterPriceWidget extends StatelessWidget {
  final String hotelName;
  final String cityName;
  final String checkingDate;
  final String checkoutDate;
  final int members;
  final int room;
  final LatLng? latLng;

  SortFilterPriceWidget(
      {super.key,
      required this.hotelName,
      required this.cityName,
      required this.checkingDate,
      required this.checkoutDate,
      required this.members,
      required this.room,
      required this.latLng});
  final FilterController filterController = Get.put(FilterController());
  final SearchingHotelName searchController = Get.find();

  final RememberMeController rememberMeController =
      Get.put(RememberMeController());
  final PriceRangeController priceRangeController =
      Get.put(PriceRangeController());
  final SearchHotelCityNameController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    Get.put(SortByController());
    final SortByController sortcontroller = Get.find();
    final height = MediaQuery.of(context).size.height;
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          //sort method---------------
          InkWell(
            onTap: () {
              sortmethod(context, height, sortcontroller);
            },
            child: SortFilterPriceButton(
                text: "Sort_by".tr,
                icon: "assets/images/sort.png",
                arrowdown: Icons.keyboard_arrow_down),
          ),
          const VerticalDivider(
            color: Colors.black,
            thickness: 1,
          ),
          //filter-------------------------------------------------------------------
          InkWell(
            onTap: () {
              filterOption(context);
            },
            child: SortFilterPriceButton(
                text: "Filters".tr,
                icon: "assets/images/filter.png",
                arrowdown: Icons.keyboard_arrow_down),
          ),
          const VerticalDivider(
            color: Colors.black,
            thickness: 1,
          ),
          //!price filtering-----------------------
          InkWell(
            onTap: () {
              showModalBottomSheet(
                backgroundColor: kWhite,
                enableDrag: true,
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Price Range (OMR)".tr,
                            style: textBoldblack,
                          ),
                          Obx(() {
                            return Column(
                              children: [
                                Slider(
                                  onChangeEnd: (value) {
                                    priceRangeController.updatePrice(value);
                                  },
                                  value: priceRangeController.price.value,
                                  min: 0,
                                  max: 10000,
                                  divisions: 100,
                                  label: priceRangeController.price.value
                                      .round()
                                      .toString(),
                                  activeColor: Colors.red,
                                  inactiveColor: Colors.red.shade100,
                                  onChanged: (double value) {
                                    priceRangeController.updatePrice(value);
                                  },
                                ),
                                Text(
                                  '${'Selected Price'.tr}: ${priceRangeController.price.value.round()} ${'OMR'.tr}',
                                  style: textBoldblack,
                                ),
                              ],
                            );
                          }),
                          height10,
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'.tr),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () async {
                                    controller.loading.value = true;
                                    final SearchHotelCityNameModel datas =
                                        SearchHotelCityNameModel(
                                      lat: latLng?.latitude,
                                      lng: latLng?.longitude,
                                      priceRangeSort: [
                                        0.00,
                                        double.parse(
                                            (priceRangeController.price.value)
                                                .toStringAsFixed(2))
                                      ],
                                      filter: {
                                        "amenities": [],
                                        "rating": [],
                                      },
                                      sorted: "Recommended",
                                      hotelName: hotelName,
                                      cityName: cityName,
                                      checkingDate: checkingDate,
                                      checkoutDate: checkoutDate,
                                      members: members,
                                      room: room,
                                    );
                                    bool success =
                                        await controller.fetchData(datas);
                                    if (success) {
                                      searchController.updateSearchQuery(
                                          '', controller.hotelList);
                                      controller.loading.value = false;
                                      Get.back();
                                    }
                                  },
                                  child: Obx(
                                    () => controller.loading.value
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: kWhite,
                                            ),
                                          )
                                        : Text('Apply'.tr),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: SortFilterPriceButton(
                text: "Price".tr,
                icon: "assets/images/ion_pricetag-outline.png",
                arrowdown: Icons.keyboard_arrow_down),
          ),
        ],
      ),
    );
  }
//! Filter method--------------------------------------------------------------------------------------

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
                          "Hotel Rating".tr,
                          [
                            "5 Star".tr,
                            "4 Star".tr,
                            "3 Star".tr,
                            "2 Star".tr,
                            "1 Star".tr
                          ],
                          filterController.hotelRatings,
                          filterController.toggleHotelRating,
                        ),
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
                          [
                            "Gym".tr,
                            "Wifi".tr,
                            "Swimming pool".tr,
                          ],
                          filterController.propertyAmenities,
                          filterController.togglePropertyAmenity,
                        ),
                        // buildFilterSection(
                        //   "Meals",
                        //   [
                        //     "Room only",
                        //     "Breakfast included",
                        //     "Breakfast + Lunch (or Dinner)"
                        //   ],
                        //   filterController.meals,
                        //   filterController.toggleMeal,
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonWidget(
                        ontap: () async {
                          controller.loading.value = false;
                          final selectedFilters =
                              filterController.getSelectedFilters();
                          final SearchHotelCityNameModel datas =
                              SearchHotelCityNameModel(
                            lat: latLng?.latitude,
                            lng: latLng?.longitude,
                            priceRangeSort: [],
                            filter: selectedFilters,
                            sorted: "Recommended",
                            hotelName: hotelName,
                            cityName: cityName,
                            checkingDate: checkingDate,
                            checkoutDate: checkoutDate,
                            members: members,
                            room: room,
                          );
                          // print(datas.filter);
                          bool success = await controller.fetchData(datas);
                          if (success) {
                            searchController.updateSearchQuery(
                                '', controller.hotelList);
                            controller.loading.value = false;
                            Get.back();
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

//! sort method--------------------------------------------------------------------------------------
  Future<dynamic> sortmethod(
      BuildContext context, double height, SortByController sortcontroller) {
    return showModalBottomSheet(
      backgroundColor: kWhite,
      enableDrag: true,
      context: context,
      builder: (context) {
        return SizedBox(
          height: height / 2.2,
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
                        height: 50,
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
                          leading: sortcontroller.sortListIcons[index] is Icon
                              ? Icon(
                                  (sortcontroller.sortListIcons[index] as Icon)
                                      .icon,
                                  size: 12, // Cast to Icon to access icon data
                                  color: sortcontroller.selectedIndex.value ==
                                          index
                                      ? Colors.red
                                      : Colors.black,
                                )
                              : ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    sortcontroller.selectedIndex.value == index
                                        ? Colors.red
                                        : Colors.black,
                                    BlendMode.srcIn,
                                  ),
                                  child: sortcontroller.sortListIcons[index]
                                      as Image, // Cast to Image to display it
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
                        controller.loading.value = true;
                        String selectedSort = sortcontroller.getSelectedSort();

                        final SearchHotelCityNameModel datas =
                            SearchHotelCityNameModel(
                          lat: latLng?.latitude,
                          lng: latLng?.longitude,
                          priceRangeSort: [],
                          filter: {
                            "amenities": [],
                            "rating": [],
                          },
                          sorted: selectedSort == 'Lowest Price'.tr
                              ? "PriceLowToHigh"
                              : selectedSort == "Highest Price".tr
                                  ? "PriceHighToLow"
                                  : selectedSort == "Hotel Star Rating".tr
                                      ? "Hotelstarrating"
                                      : "Recommended",
                          hotelName: hotelName,
                          cityName: cityName,
                          checkingDate: checkingDate,
                          checkoutDate: checkoutDate,
                          members: members,
                          room: room,
                        );
                        bool success = await controller.fetchData(datas);
                        if (success) {
                          controller.loading.value = false;
                          searchController.updateSearchQuery(
                              '', controller.hotelList);
                          Get.back();
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
                  height: 50,
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
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          height10,
        ],
      ),
    );
  }
}
