import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/common/button/button.dart';
import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:e_concierge_tourism/controller/api/discout_offer/discount_offer.dart';
import 'package:e_concierge_tourism/controller/service/location_service/location_service.dart';
import 'package:e_concierge_tourism/view/home/todays_offer_detail_page.dart';
import 'package:e_concierge_tourism/view/home/widgets/discout_offer.dart';
import 'package:e_concierge_tourism/view/home/widgets/heading_text.dart';
import 'package:e_concierge_tourism/view/hotel_booking/hotel_list/hotel_ilst.dart';
import 'package:e_concierge_tourism/view/hotel_booking/search_hotels/widgets/bottom_sheet.dart';
import 'package:e_concierge_tourism/view/hotel_booking/search_hotels/widgets/checkin_checkout.dart';
import 'package:e_concierge_tourism/view/hotel_booking/search_hotels/widgets/date_picker_screen.dart';
import 'package:e_concierge_tourism/common/textform/textform_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../constant/styles/sizedbox.dart';
import '../../../getx/dropdown_chalet_property.dart';
import '../../../controller/model/hotel_bookings/hotel_booking_entire/search_hotels_model.dart';
import '../../../controller/api/hotel_booking/hotel_search/search_hotel_controller.dart';
import '../../../getx/count_of_guest.dart';
import '../../../getx/date_picker_controller.dart';
import '../../../getx/search_controller.dart';
import '../../../common/cupertino_widget/appbar.dart';
import '../../../common/google_search_api/google_search_api.dart';

class SearchHotel extends StatelessWidget {
  final int index;
  SearchHotel({super.key, required this.index});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//?---------------------------------------------------------------------------------------
//?---------------------------------------------------------------------------------------
  final searchingCityController = TextEditingController();
  final searchingHotelController = TextEditingController();
  String id = '';

  LocationService locationController = Get.find();
  final DatePickerController datePickercontroller = Get.find();
  final RxBool loading = false.obs;
  var currentLocationLoading = false.obs;
  final SearchHotelCityNameController searchHotelCityController =
      Get.put(SearchHotelCityNameController());
  final CounterController counterControllerFind = Get.find();
  final PropertyTypeController propertySelect =
      Get.put(PropertyTypeController());
//?---------------------------------------------------------------------------------------
//?---------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    datePickercontroller.validateDates();
    Get.put(SearchLocationController());
    Get.put(SearchControllerHotel());
    Get.put(SearchCityController());
    searchingCityController.text = propertySelect.searchCityController.value;
    id = propertySelect.cityId.value;
    // print(id);
    List<String> guest = ["room".tr, 'adult'.tr, 'children'.tr];
    final discountController = Get.put(DiscountOfferApi());

    //------------------------------------------------------------------------------

    return Scaffold(
      appBar: MyAppBar(
        // trailingIOS: Padding(
        //   padding: const EdgeInsets.only(
        //     left: 10,
        //     bottom: 10,
        //     top: 5,
        //   ),
        //   child: ElevatedButton.icon(
        //     icon: Image.asset(
        //       'assets/images/Mask group.png',
        //       height: 15,
        //       width: 15,
        //     ),
        //     style: const ButtonStyle(
        //         backgroundColor: WidgetStatePropertyAll(darkRed)),
        //     label: Text(
        //       "omr".tr,
        //       style: const TextStyle(color: kWhite, fontSize: 10),
        //     ),
        //     onPressed: () {},
        //   ),
        // ),
        title: "search_hotels".tr,
        // actionsANDROID: const [
        // Padding(
        //   padding: const EdgeInsets.all(12.0),
        //   child: ElevatedButton.icon(
        //     icon: Image.asset(
        //       'assets/images/Mask group.png',
        //       height: 15,
        //       width: 15,
        //     ),
        //     style: const ButtonStyle(
        //         backgroundColor: WidgetStatePropertyAll(darkRed)),
        //     label: Text(
        //       "omr".tr,
        //       style: const TextStyle(color: kWhite, fontSize: 10),
        //     ),
        //     onPressed: () {},
        //   ),
        // )
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Container(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? kBlack
                        : kWhite,
                    width: double.infinity,
                    child: GetBuilder<SearchControllerHotel>(
                      builder: (controller) => Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("search_by".tr),
                            height10,
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showMenu(
                                      color: kWhite,
                                      context: context,
                                      position: const RelativeRect.fromLTRB(
                                          0, 100, 0, 0),
                                      items: [
                                        PopupMenuItem(
                                          value: 'city'.tr,
                                          child: Text('city'.tr),
                                        ),
                                        PopupMenuItem(
                                          value: 'hotel'.tr,
                                          child: Text('hotel'.tr),
                                        ),
                                      ],
                                      elevation: 8.0,
                                    ).then((value) {
                                      if (value != null) {
                                        controller.updateSelectedOption(value);
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 55,
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          topLeft: Radius.circular(10)),
                                      color: Color(0xFFD3DEFF),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.location_city),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Obx(() => Text(
                                            controller.selectedOption.value)),
                                        const Icon(
                                            Icons.keyboard_arrow_down_rounded)
                                      ],
                                    ),
                                  ),
                                ),

                                //! search bar-----------------------------------------------------------------------------

                                Expanded(
                                  child: Obx(
                                    () => SearchBar(
                                      onTap: () async {
                                        if (controller.selectedOption.value ==
                                            'city'.tr) {
                                          focus.unfocus();
                                          FocusScopeNode currentfocus =
                                              FocusScope.of(context);
                                          if (!currentfocus.hasPrimaryFocus) {
                                            currentfocus.unfocus();
                                          }
                                          await showSearch<String>(
                                            context: context,
                                            delegate: CitySearchDelegate(),
                                          );
                                        }
                                      },
                                      backgroundColor:
                                          const WidgetStatePropertyAll(
                                        Color(0xFFEDF0F9),
                                      ),
                                      focusNode: focus,
                                      controller:
                                          controller.selectedOption.value ==
                                                  'city'.tr
                                              ? searchingCityController
                                              : searchingHotelController,
                                      trailing: [
                                        IconButton(
                                          onPressed: () async {
                                            // currentLocationLoading.value = true;
                                            // if (currentLocationLoading.value) {
                                            //   Get.defaultDialog(
                                            //     barrierDismissible: false,
                                            //     title: "",
                                            //     content: const Column(
                                            //       mainAxisSize:
                                            //           MainAxisSize.min,
                                            //       children: [
                                            //         CircularProgressIndicator(
                                            //           color: darkRed,
                                            //         ),
                                            //         SizedBox(height: 15),
                                            //         Text(
                                            //           "Loading...",
                                            //           style: TextStyle(
                                            //             fontSize: 16,
                                            //             color: Colors.black,
                                            //             fontWeight:
                                            //                 FontWeight.w500,
                                            //           ),
                                            //         ),
                                            //       ],
                                            //     ),
                                            //     backgroundColor: kWhite,
                                            //     radius: 10,
                                            //   );
                                            // }
                                            final result =
                                                await locationController
                                                    .getCurrentCity();
                                            searchingCityController.text =
                                                result ?? '';
                                            currentLocationLoading.value =
                                                false;
                                            // Get.back();
                                          },
                                          icon: const Icon(Icons.gps_fixed),
                                        )
                                      ],
                                      hintText: controller
                                                  .selectedOption.value ==
                                              'city'.tr
                                          ? "Search City".tr
                                          : "${"Enter".tr} ${controller.selectedOption.value} ${"Name".tr}",
                                      elevation:
                                          const WidgetStatePropertyAll(0),
                                      shape: WidgetStateProperty.all(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)))),
                                    ),
                                  ),
                                )
                              ],
                            ),

                            height10,

                            //? checkin & Checkout ---------------------------------------------------------------------------

                            Row(
                              children: [
                                Obx(
                                  () => CheckInCheckout(
                                    text: "checkin".tr,
                                    date: datePickercontroller.getFormattedDate(
                                        datePickercontroller
                                            .selectedStartDate.value),
                                    onTap: () {
                                      focus.unfocus();
                                      Get.to(() => DatePickerScreen());
                                    },
                                  ),
                                ),
                                width10,
                                Obx(
                                  () => CheckInCheckout(
                                    text: "checkout".tr,
                                    date: datePickercontroller.getFormattedDate(
                                        datePickercontroller
                                            .selectedEndDate.value),
                                    onTap: () {
                                      Get.to(() => DatePickerScreen());
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),

                            //? Room Members----------------------------

                            height10,
                            Text("Room_members".tr),
                            height10,
                            //? bottom sheeet for adding adult and childerns -----
                            BottomSheetGustInfo(
                                counterControllerFind: counterControllerFind,
                                guest: guest),

                            //? search----------------------------
                            height15,
                            Obx(
                              () => ButtonWidget(
                                text: loading.value == true
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          backgroundColor: kWhite,
                                          color: darkRed,
                                        ),
                                      )
                                    : Text(
                                        "search".tr,
                                        style: textColorwhite,
                                      ),
                                ontap: () async {
                                  DateTime today = DateTime(DateTime.now().year,
                                      DateTime.now().month, DateTime.now().day);

                                  if (datePickercontroller
                                          .selectedStartDate.value
                                          .isBefore(today) ||
                                      datePickercontroller.selectedEndDate.value
                                          .isBefore(today)) {
                                    showAnimatedSnackBar(
                                      'Invalid date cannot be in the past',
                                      kBlack,
                                    );
                                  } else if (datePickercontroller
                                      .selectedStartDate.value
                                      .isAfter(datePickercontroller
                                          .selectedEndDate.value)) {
                                    showAnimatedSnackBar(
                                      'Please select a valid date range'.tr,
                                      kBlack,
                                    );
                                  } else if (datePickercontroller
                                      .selectedStartDate.value
                                      .isAtSameMomentAs(datePickercontroller
                                          .selectedEndDate.value)) {
                                    showAnimatedSnackBar(
                                      'Check-out date must be after Check-in date'
                                          .tr,
                                      kBlack,
                                    );
                                  } else if (searchingCityController
                                          .text.isEmpty &&
                                      searchingHotelController.text.isEmpty) {
                                    showAnimatedSnackBar(
                                      'Enter the city or hotel you want to stay'
                                          .tr,
                                      kBlack,
                                    );
                                  } else {
                                    focus.unfocus();
                                    listHotel();
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                //! discount deals ---------------------------------

                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => discountController.discountOfferData.isNotEmpty
                          ? HeadingText(heading: "todays_offer".tr)
                          : const SizedBox()),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Obx(
                          () => Row(
                              children: List.generate(
                            discountController.discountOfferData.length,
                            (index) {
                              final data =
                                  discountController.discountOfferData[index];

                              return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(TodaysOfferDetailPage(
                                        minSpend: data.minSpend,
                                        type: data.type,
                                        code: data.promoCode ?? '',
                                        startDate: data.startDate,
                                        discounPercentage:
                                            data.discountPercentage,
                                        endDate: data.endDate,
                                        description: data.description,
                                        propertyName:
                                            data.chaletName.toString(),
                                        title: data.title,
                                      ));
                                    },
                                    child: DiscountOffer(
                                        discountPercentage: discountController
                                            .discountOfferData[index]
                                            .discountPercentage
                                            .toString(),
                                        discounPercentage2: discountController
                                            .discountOfferData[index]
                                            .discountPercentage,
                                        discountCondition: discountController
                                            .discountOfferData[index]
                                            .description),
                                  ));
                            },
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//searching hotel --------------------------------------------------------
  Future<void> listHotel() async {
    double? lat, lng;
    if (formKey.currentState!.validate() &&
        counterControllerFind.counters[0] > 0 &&
        counterControllerFind.counters[1] > 0) {
      String city = searchingCityController.text;
      final SearchControllerHotel controller = Get.find();
      final SearchLocationController searchLocationController = Get.find();
      if (searchLocationController.selectedId.value.isNotEmpty)
        id = searchLocationController.selectedId.value;
      final lang = searchLocationController.detectedLanguage.value;
     print(id);
      if (controller.selectedOption.value != "hotel".tr) {
        final responseCity = await getLocationAddress(id);
        if (responseCity != null) {
          lat = responseCity['lat'];
          lng = responseCity['lng'];
        }
      }
      final SearchHotelCityNameModel datas = SearchHotelCityNameModel(
        lat: lat,
        lng: lng,
        priceRangeSort: [],
        filter: {
          "amenities": ["pool", "gym"],
          "rating": [4, 5],
        },
        sorted: 'Recommended',
        hotelName: controller.selectedOption.value == "hotel".tr &&
                searchingHotelController.text.isNotEmpty
            ? searchingHotelController.text.trim()
            : "",
        cityName:
            searchingCityController.text == searchingCityController.text &&
                    controller.selectedOption.value == "hotel".tr
                ? ""
                : city,
        checkingDate: datePickercontroller.getFormattedDateReverse(
            datePickercontroller.selectedStartDate.value),
        checkoutDate: datePickercontroller.getFormattedDateReverse(
            datePickercontroller.selectedEndDate.value),
        members: counterControllerFind.counters[1] +
            counterControllerFind.counters[2],
        room: counterControllerFind.counters[0],
      );
      try {
        loading.value = true;
        bool success = await searchHotelCityController.fetchData(datas);

        if (success == true && !searchHotelCityController.isClosed) {
          Get.to(() => HotelList(
            cityLatLng:(lat != null && lng != null)? LatLng(lat,lng)  : null,
                hotelName: searchingHotelController.text.isNotEmpty
                    ? searchingHotelController.text.trim()
                    : "",
                cityName: searchingCityController.text ==
                            searchingCityController.text &&
                        controller.selectedOption.value == "hotel".tr
                    ? ""
                    : searchingCityController.text.trim(),
                checkingDate: datePickercontroller.getFormattedDateReverse(
                    datePickercontroller.selectedStartDate.value),
                checkoutDate: datePickercontroller.getFormattedDateReverse(
                    datePickercontroller.selectedEndDate.value),
                members: counterControllerFind.counters[1] +
                    counterControllerFind.counters[2],
                room: counterControllerFind.counters[0],
                searchData: datas,
                index: index,
              ));
        } else {
          //snackbar---
          if (searchHotelCityController.errormessage.value.isNotEmpty) {
            showAnimatedSnackBar(
              searchHotelCityController.errormessage.value,
              kBlack,
            );
          }

          loading.value = false;
        }
      } catch (e) {
        showAnimatedSnackBar(
          e.toString(),
          darkRed,
        );
        loading.value = false;
      }
    } else {
      Get.snackbar(
          'Failed to search Hotels'.tr, 'Pls select Rooms and Members'.tr);
      loading.value = false;
    }
    loading.value = false;
  }
}
