import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/controller/api/chalets_booking/chalet_list_and_detail/chalet_search_api.dart';
import 'package:e_concierge_tourism/controller/api/discout_offer/discount_offer.dart';
import 'package:e_concierge_tourism/getx/dropdown_chalet_property.dart';
import 'package:e_concierge_tourism/common/button/button.dart';
import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import 'package:e_concierge_tourism/common/textform/textform_field.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:e_concierge_tourism/view/chalets_booking/chalet_list/chalet_list.dart';
import 'package:e_concierge_tourism/view/home/todays_offer_detail_page.dart';
import 'package:e_concierge_tourism/view/home/widgets/discout_offer.dart';
import 'package:e_concierge_tourism/view/home/widgets/heading_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../constant/styles/sizedbox.dart';
import '../../../controller/model/chalet_bookings/chalet_booking_entire/chalet_searching.dart';
import '../../../getx/count_of_guest.dart';
import '../../../getx/date_picker_controller.dart';
import '../../../common/google_search_api/google_search_api.dart';
import '../../hotel_booking/search_hotels/widgets/bottom_sheet.dart';
import '../../hotel_booking/search_hotels/widgets/checkin_checkout.dart';
import '../../hotel_booking/search_hotels/widgets/date_picker_screen.dart';

class ChaletSearchPage extends StatelessWidget {
  ChaletSearchPage({super.key});
  //?---------------------------------------------------------------------------
  final searchCityController = TextEditingController();
  final propertyTypeController = TextEditingController();
  final DatePickerController datePickerController = Get.find();
  final PropertyTypeController propertySelect =
      Get.put(PropertyTypeController());
  final ChaletSearchApi chaletSearchApiController = Get.put(ChaletSearchApi());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final CounterController counterControllerFind = Get.find();
  final discountController = Get.put(DiscountOfferApi());

  final loading = false.obs;

//?-----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    List<String> guest = ['adult'.tr, 'children'.tr];

    Get.put(SearchLocationController());
    Get.put(SearchCityController());
    propertyTypeController.text = propertySelect.selectedPropertyType.value;
    searchCityController.text = propertySelect.searchCityController.value;
    final FocusNode focus = FocusNode();

    return Scaffold(
      appBar: MyAppBar(title: "Search chalet".tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "select_city".tr,
                            style: textBoldblack,
                          ),
                          height10,
                          TextFormFieldWidget(
                            onTap: () async {
                              FocusScopeNode currentfocus =
                                  FocusScope.of(context);
                              if (!currentfocus.hasPrimaryFocus) {
                                currentfocus.unfocus();
                              }
                              await showSearch<String>(
                                context: context,
                                delegate: CitySearchDelegate(),
                              );
                            },
                            focusNode: focus,
                            validator: (value) => value == null || value.isEmpty
                                ? "Please select city".tr
                                : null,
                            controller: searchCityController,
                            hintText: "Search city that you like to stay".tr,
                            hintStyle: const TextStyle(fontSize: 15),
                          ),
                          height10,
                          height10,
                          Row(
                            children: [
                              Obx(
                                () => CheckInCheckout(
                                  text: "checkin".tr,
                                  date: datePickerController.getFormattedDate(
                                    datePickerController
                                        .selectedStartDate.value,
                                  ),
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
                                  date: datePickerController.getFormattedDate(
                                    datePickerController.selectedEndDate.value,
                                  ),
                                  onTap: () {
                                    focus.unfocus();
                                    Get.to(() => DatePickerScreen());
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              height10,
                            ],
                          ),
                          height20,
                          Text("Adults & Childrens".tr),
                          height10,
                          //? bottom sheeet---------------------------
                          BottomSheetGustInfo(
                              checkCHALET: "CHALET",
                              counterControllerFind: counterControllerFind,
                              guest: guest),
                          height20,
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Obx(
                              () => ButtonWidget(
                                ontap: () async {
                                  focus.unfocus();
                                  chaletList();
                                },
                                text: loading.value
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          backgroundColor: kWhite,
                                          color: darkRed,
                                        ),
                                      )
                                    : Text(
                                        "search_chalets".tr,
                                        style: textBoldwhite,
                                      ),
                              ),
                            ),
                          ),
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
                                      propertyName: data.chaletName.toString(),
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
    );
  }

  //the searching data sending to server for listing chalet

  Future<void> chaletList() async {
    double? lat, lng;
    if (formKey.currentState!.validate()) {
      loading.value = true;
      final adults = counterControllerFind.counters[1];
      final children = counterControllerFind.counters[2];
      final members = adults + children;
      String city = searchCityController.text;
      final SearchLocationController searchLocationController = Get.find();
      final id = searchLocationController.selectedId.value;
      final lang = searchLocationController.detectedLanguage.value;
      // if (lang == 'ar') {
      final responseCity = await getLocationAddress(id);
      if (responseCity != null) {
        lat = responseCity['lat'];
        lng = responseCity['lng'];
      }
      // }
      ChaletSearchRequestModel model1 = ChaletSearchRequestModel(
        lat: lat,
        lng: lng,
        amenities: [],
        sorted: 'Recommended',
        rating: 0,
        // adults: 2,
        // children: 2,
        members: members.toString(),
        cityName: city,
        checkinDate: datePickerController.getFormattedDateReverse(
            datePickerController.selectedStartDate.value),
        checkoutDate: datePickerController.getFormattedDateReverse(
            datePickerController.selectedEndDate.value),
      );
      try {
        final success = await chaletSearchApiController.fetchChalets(model1);

        if (success && chaletSearchApiController.chaletList.isNotEmpty) {
          Get.to(() => ChaletListPage(
            cityLatLng: (lat !=null && lng != null) ? LatLng(lat, lng):  null,
                city: city,
              ));
        } else {
          showAnimatedSnackBar("chalet_not_available_message".tr, kBlack);
        }
      } catch (e) {
        showAnimatedSnackBar(e.toString(), kBlack);
      } finally {
        loading.value = false;
      }
    } else {
      showAnimatedSnackBar("Please enter the city name".tr, kBlack);
    }
  }
}
