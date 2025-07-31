import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_concierge_tourism/common/promocode_widget/promocode_widget.dart';
import 'package:e_concierge_tourism/common/snackbar/snackbar.dart';
import 'package:e_concierge_tourism/constant/images/demo.dart';
import 'package:e_concierge_tourism/controller/api/chalets_booking/booking/booking.dart';
import 'package:e_concierge_tourism/controller/api/chalets_booking/chalet_list_and_detail/chalet_search_api.dart';
import 'package:e_concierge_tourism/controller/api/hotel_booking/hotel_price/hotel_price_api.dart';
import 'package:e_concierge_tourism/controller/model/chalet_bookings/chalet_booking_entire/chalet_booking.dart';
import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/review_page_notf.dart'
    as hotel;
import 'package:e_concierge_tourism/getx/booking_refund_options.dart';
import 'package:e_concierge_tourism/getx/count_of_guest.dart';
import 'package:e_concierge_tourism/language/controller/transalate_controller.dart';
import 'package:e_concierge_tourism/view/auth/login_page/login_page.dart';
import 'package:e_concierge_tourism/view/bottom_nav.dart/bottom_nav.dart';
import 'package:e_concierge_tourism/view/my_bookings/upcoming/view_more_details_page.dart';
import 'package:e_concierge_tourism/view/payment/payment_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../getx/personal_detail_controller.dart';
import '../../../getx/remember_me.dart';
import '../../../constant/styles/colors.dart';
import '../../../constant/styles/sizedbox.dart';
import '../../../constant/styles/textstyle.dart';
import '../../../getx/checkedbox.dart';
import '../../../getx/date_picker_controller.dart';
import '../../../common/personal_details_widget/personal_details_widget.dart';
import '../../../common/textform/textform_field.dart';
import '../../home/widgets/heading_text.dart';
import '../../hotel_booking/components/bottom_nav_button.dart';
import '../../hotel_booking/reviewbooking/widgets/payment_options.dart';
import '../../hotel_booking/reviewbooking/widgets/refund_cancellation_options.dart';
import '../../hotel_booking/successs_page.dart/success_booking.dart';

class ChaletReviewBookingPage extends StatefulWidget {
  final String chaletImage;
  final int chaletId;
  final int? promoId;
  const ChaletReviewBookingPage({
    super.key,
    required this.chaletImage,
    required this.chaletId,
    this.promoId,
  });

  @override
  State<ChaletReviewBookingPage> createState() =>
      _ChaletReviewBookingPageState();
}

class _ChaletReviewBookingPageState extends State<ChaletReviewBookingPage> {
  late bool showError;
  @override
  void initState() {
    super.initState();
    getPriceDetails();
    showError = false;
  }

  final EmailForProfile emailController = Get.put(EmailForProfile());
  bool _hasSetSavedData = false;
  String countryCode = '+968';
  int members = 0;
  String promocode = '';
  String selectedISOCode = 'OM';

  //textediting controller
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final firstName1 = TextEditingController();
  final lastName1 = TextEditingController();
  final email1 = TextEditingController();
  final phoneNumber2 = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final LanguageController languageController = Get.find();
  final HotelPriceApi hotelPriceController = Get.put(HotelPriceApi());
  final DatePickerController datePickercontroller = Get.find();
  final CounterController counterControllerFind = Get.find();
  final PaymentOptionsBooking paymentSelectionController =
      Get.put(PaymentOptionsBooking());
  String startDate = '';
  String endDate = '';

  getPriceDetails() {
    members =
        (counterControllerFind.counters[1] + counterControllerFind.counters[2]);
    startDate = DateFormat('yyyy-MM-dd')
        .format(datePickercontroller.selectedStartDate.value);
    endDate = DateFormat('yyyy-MM-dd')
        .format(datePickercontroller.selectedEndDate.value);
    // const id = 38;
    hotelPriceController.getBookingPriceDetails(
        [], startDate, endDate, widget.promoId,
        isHotel: false, chaletId: widget.chaletId, promocode: promocode);
  }

  //
  @override
  Widget build(BuildContext context) {
    // dependency GetX
    final ApplyPromoController applyPromoController =
        Get.put(ApplyPromoController());
    ChaletSearchApi chaletDetail = Get.find();
    final BookingTermsAndCondition controller =
        Get.put(BookingTermsAndCondition());
    final PersonalDetailController personalController =
        Get.put(PersonalDetailController());
    final TaxNumberController taxController = Get.put(TaxNumberController());
    final bookingController = Get.put(ChaletsBookingApi());
    final data = chaletDetail.chaletListDetail[0];
    //

    Map<String, int> calculateRangeOfDays() {
      TimeOfDay checkInTime = datePickercontroller.checkInTime.value;
      TimeOfDay checkOutTime = datePickercontroller.checkOutTime.value;
      DateTime startDate = datePickercontroller.selectedStartDate.value;
      DateTime endDate = datePickercontroller.selectedEndDate.value;

      int nights = endDate.difference(startDate).inDays;

      if (endDate.day == startDate.day &&
          (checkOutTime.hour < checkInTime.hour ||
              (checkOutTime.hour == checkInTime.hour &&
                  checkOutTime.minute < checkInTime.minute))) {
        nights--;
      }

      int mornings = nights + 1;

      return {'nights': nights, 'mornings': mornings};
    }

    //String nightdaysNumber = "${calculateRangeOfDays()['nights']}";
    String nightdays = "${calculateRangeOfDays()['nights']} ${'nights'.tr}";
    String morningDays = "${calculateRangeOfDays()['mornings']} ${'days'.tr}";
    String nightdaysCount = "${calculateRangeOfDays()['nights']}";
    String morningDaysCount = "${calculateRangeOfDays()['morning']}";
    String day = "${calculateRangeOfDays()['morning']} ${"day".tr}";
    String night = "${calculateRangeOfDays()['nights']} ${"night".tr}";
    //int nights = int.tryParse(nightdaysNumber) ?? 0;
    int taX = 10;

    // double totalpriceAll = double.tryParse(data.pricePerNight.toString())! + 10;
    // var discountPrice = 5;
    // double totalIncludeTax = totalpriceAll;
    var size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    // double totalpriceTaxWithDiscount = totalIncludeTax - discountPrice;

    return Scaffold(
      appBar: MyAppBar(title: "Review Booking".tr),
      body: Obx(
        () {
          final priceDetails = hotelPriceController.priceData.value;
          final totalAmmtToBePaid = priceDetails.totalAmountToBePaid;
          final discountPrice = priceDetails.discountPrice;
          final priceWithTax = priceDetails.totalRoomsPriceWithTax;
          final taxService = priceDetails.taxAndServices;
          final mealTax = priceDetails.mealTax;
          final roomPrice =
              priceDetails.roomPriceWithMealAndNumberOfRoomsAndNumberOfDays;
          return hotelPriceController.loading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: kWhite,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              chaletDetail
                                                  .chaletListDetail[0].name
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontSize: width * 0.05,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (chaletDetail.chaletListDetail[0]
                                                        .propertyType?.icon !=
                                                    null &&
                                                chaletDetail.chaletListDetail[0]
                                                        .propertyType?.type !=
                                                    null)
                                              Row(
                                                children: [
                                                  CachedNetworkImage(
                                                    width: 20,
                                                    height: 20,
                                                    imageUrl: chaletDetail
                                                        .chaletListDetail[0]
                                                        .propertyType!
                                                        .icon!,
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const SizedBox.shrink(),
                                                  ),
                                                  // ImageIcon(
                                                  //   NetworkImage(chaletDetail
                                                  //       .chaletListDetail[0]
                                                  //       .propertyType!
                                                  //       .icon!),
                                                  //   size: 18,
                                                  // ),
                                                  width5,
                                                  Expanded(
                                                    child: Text(
                                                      chaletDetail
                                                          .chaletListDetail[0]
                                                          .propertyType!
                                                          .type!,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  width10,
                                                ],
                                              ),
                                            // Row(
                                            //   children:
                                            //       List.generate(5, (index) {
                                            //     if (index < 4) {
                                            //       return const Icon(
                                            //         Icons.star,
                                            //         color: Colors.amber,
                                            //         size: 13,
                                            //       );
                                            //     } else {
                                            //       return const Icon(
                                            //         Icons.star_half,
                                            //         color: Colors.amber,
                                            //         size: 13,
                                            //       );
                                            //     }
                                            //   }),
                                            // ),
                                            SizedBox(height: height * 0.01),
                                            Row(
                                              children: [
                                                Icon(Icons.location_on,
                                                    size: width * 0.05),
                                                Text(data.cityName.toString(),
                                                    style: TextStyle(
                                                        fontSize:
                                                            width * 0.03)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                        child: CachedNetworkImage(
                                          imageUrl: data
                                              .chaletImages![0].imageUrl
                                              .toString(),
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Center(
                                              child:
                                                  Image.network(loadingImage)),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "checkin".tr,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                        Text(
                                          datePickercontroller.getFormattedDate(
                                              datePickercontroller
                                                  .selectedStartDate.value),
                                        )
                                      ],
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: kBlue),
                                        shape: BoxShape.circle,
                                        color: Colors.lightBlue[100],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              nightdaysCount == 1.toString() &&
                                                      nightdaysCount ==
                                                          0.toString()
                                                  ? night
                                                  : nightdays,
                                              style:
                                                  const TextStyle(fontSize: 8),
                                            ),
                                            const Text(
                                              "&",
                                              style: TextStyle(fontSize: 8),
                                            ),
                                            Text(
                                              morningDaysCount ==
                                                          0.toString() &&
                                                      morningDaysCount ==
                                                          1.toString()
                                                  ? day
                                                  : morningDays,
                                              style:
                                                  const TextStyle(fontSize: 7),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "checkout".tr,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                        Text(
                                          datePickercontroller.getFormattedDate(
                                              datePickercontroller
                                                  .selectedEndDate.value),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        //! refund cancellation policy------------------------------------

                        // RefundCancellationPolicy(
                        //   check: "CHALET",
                        //   cancellationPolicy: data.cancellationPolicy ?? [],
                        // ),
                        //! property rules -=----------------
                        if (priceDetails.acceptedPayments != null &&
                            priceDetails.acceptedPayments!.isNotEmpty)
                          //!payment options----------------------------
                          PaymentOptions(
                            acceptedPayments: priceDetails.acceptedPayments!,
                          ),

                        //!personal detailss--------

                        Obx(() {
                          final data = emailController;
                          List<String> options = ["Myself", "Someone Else"];
                          if (emailController.userName.isNotEmpty &&
                              data.lastName.isNotEmpty &&
                              data.email.isNotEmpty &&
                              personalController.currentOption.value ==
                                  "Myself" &&
                              !_hasSetSavedData) {
                            firstName.text =
                                emailController.firstname.value.isEmpty
                                    ? emailController.userName.value
                                    : emailController.firstname.value;
                            lastName.text =
                                emailController.lastName1.value.isEmpty
                                    ? emailController.lastName.value
                                    : emailController.lastName1.value;
                            email.text = emailController.email.value;
                            phoneNumber.text =
                                emailController.phoneNumber.value;
                            _hasSetSavedData = true;
                          } else {
                            if (data.userName.value.isNotEmpty &&
                                personalController.currentOption.value ==
                                    "Someone Else" &&
                                _hasSetSavedData) {
                              firstName.text = firstName1.text;
                              lastName.text = lastName1.text;
                              email.text = email1.text;
                              phoneNumber.text = phoneNumber2.text;

                              _hasSetSavedData = false;
                            }
                          }
                          return Card(
                            elevation: 4,
                            color: kWhite,
                            child: Form(
                              key: formkey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 15),
                                    child: HeadingText(
                                        heading: "I am booking for".tr),
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                        fillColor: const WidgetStatePropertyAll(
                                            darkRed),
                                        value: options[0],
                                        groupValue: personalController
                                            .currentOption.value,
                                        onChanged: (value) {
                                          personalController
                                              .changeOption(value.toString());
                                        },
                                      ),
                                      Text("myself".tr, style: textBoldblack),
                                      width10,
                                      Radio(
                                        fillColor: const WidgetStatePropertyAll(
                                            darkRed),
                                        value: options[1],
                                        groupValue: personalController
                                            .currentOption.value,
                                        onChanged: (value) {
                                          personalController
                                              .changeOption(value.toString());
                                        },
                                      ),
                                      Text("someone_else".tr,
                                          style: textBoldblack),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            DropdownWidget(),
                                            width10,
                                            Expanded(
                                              child: TextFormFieldWidget(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Please Enter Firstname";
                                                  }
                                                  return null;
                                                },
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                color: kWhite,
                                                controller: firstName,
                                                keyboardType:
                                                    TextInputType.name,
                                                label: Text(
                                                  'FIRSTNAME'.tr,
                                                  style: const TextStyle(
                                                      fontSize: 7),
                                                ),
                                              ),
                                            ),
                                            width10,
                                            Expanded(
                                              child: TextFormFieldWidget(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Please Enter Lastname";
                                                  }
                                                  return null;
                                                },
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                color: kWhite,
                                                controller: lastName,
                                                keyboardType:
                                                    TextInputType.name,
                                                label: Text(
                                                  'LASTNAME'.tr,
                                                  style: const TextStyle(
                                                      fontSize: 7),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        height10,
                                        TextFormFieldWidget(
                                          validator: (value) {
                                            return null;
                                          },
                                          controller: email,
                                          label: Text(
                                            'EMAIL'.tr,
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        ),
                                        height10,
                                        SizedBox(
                                          height: 90,
                                          child: IntlPhoneField(
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            pickerDialogStyle:
                                                PickerDialogStyle(
                                              searchFieldInputDecoration:
                                                  InputDecoration(
                                                      labelText:
                                                          'Search country'.tr),
                                              backgroundColor: kWhite,
                                            ),
                                            controller: phoneNumber,
                                            initialCountryCode: selectedISOCode,
                                            invalidNumberMessage:
                                                "invalid_mobile_number".tr,
                                            validator: (phone) {
                                              if (phone != null &&
                                                  phone.number.isEmpty) {
                                                return "please_enter_contact_number"
                                                    .tr;
                                                // Get.snackbar(
                                                //   'validation_failed'.tr,
                                                //   'please_enter_contact_number'.tr,
                                                //   backgroundColor: Colors.red,
                                                //   colorText: Colors.white,
                                                // );
                                                // return "enter_contact_no".tr;
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                              fillColor: kWhite,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                borderSide: BorderSide(),
                                              ),
                                            ),
                                            languageCode: languageController
                                                        .selectedLanguage
                                                        .value ==
                                                    'English'
                                                ? "en"
                                                : 'ar',
                                            onChanged: (phone) {},
                                            onCountryChanged: (country) {
                                              selectedISOCode = country.code;
                                              countryCode =
                                                  '+${country.dialCode}';
                                            },
                                          ),
                                        ),
                                        Obx(
                                          () => Row(
                                            children: [
                                              GetPlatform.isIOS
                                                  ? CupertinoCheckbox(
                                                      activeColor: kWhite,
                                                      checkColor: kBlack,
                                                      value: taxController
                                                          .isChecked.value,
                                                      onChanged: (newValue) {
                                                        taxController.isChecked
                                                            .value = newValue!;
                                                      },
                                                    )
                                                  : Checkbox(
                                                      fillColor:
                                                          const WidgetStatePropertyAll(
                                                              lightgrey),
                                                      activeColor: kWhite,
                                                      checkColor: kBlack,
                                                      value: taxController
                                                          .isChecked.value,
                                                      onChanged: (newValue) {
                                                        taxController.isChecked
                                                            .value = newValue!;
                                                      },
                                                    ),
                                              Expanded(
                                                child: Text(
                                                  overflow:
                                                      TextOverflow.visible,
                                                  "vat_or_tax_number".tr,
                                                  style: textColorblack,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  height10,
                                ],
                              ),
                            ),
                          );
                        }),
                        //!promocode-----------------------------------------------------------

                        PromoCodeWidget(
                          promocode: promocode,
                          isApplied: priceDetails.isPromocodeApplied,
                          isChalet: true,
                          applyCode: (model) async {
                            if (model != null) {
                              model.checkinDate = startDate;
                              model.checkoutDate = endDate;
                              model.chalet = widget.chaletId;
                              // final re = await applyPromoController
                              //     .applyPromocode(model);
                              // if (re != null) {
                              //   if (priceWithTax != null && priceWithTax > 0) {
                              //     hotelPriceController
                              //         .priceData.value.totalAmountToBePaid = re;
                              //     hotelPriceController
                              //             .priceData.value.discountPrice =
                              //         double.parse((priceWithTax - re)
                              //             .toStringAsFixed(2));
                              //   }
                              promocode = model.promocode ?? '';
                              getPriceDetails();
                              // }
                              setState(() {});
                            }
                          },
                          clear: () {
                            promocode = '';
                            getPriceDetails();
                          },
                        ),
                        //!--- price break up----------------------------------------------------------------
                        Card(
                          elevation: 4,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "price_break_up".tr,
                                  style: textBoldblack,
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("base_price".tr),
                                    Text(roomPrice.toString()),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("tax_service_fees".tr),
                                    Text("$taxService OMR"),
                                  ],
                                ),
                                const Divider(),
                                if (mealTax != null && mealTax > 0) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("meal_tax".tr),
                                      Text("$mealTax OMR"),
                                    ],
                                  ),
                                  const Divider(),
                                ],
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total Amount".tr,
                                        style: const TextStyle()),
                                    Text("$priceWithTax OMR",
                                        style: const TextStyle()),
                                  ],
                                ),
                                if (discountPrice! > 0) ...[
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Discount Price".tr,
                                          style: const TextStyle()),
                                      Text("-$discountPrice"),
                                    ],
                                  ),
                                ],
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("total_amount_to_be_paid".tr,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text("$totalAmmtToBePaid OMR",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                            // ),
                          ),
                        ),
                        height10,

                        //! terms and condition checking mark
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Checkbox(
                                fillColor:
                                    const WidgetStatePropertyAll(lightgrey),
                                activeColor: kWhite,
                                checkColor: kBlack,
                                value: controller.isChecked.value,
                                onChanged: (newValue) {
                                  controller.isChecked.value = newValue!;
                                },
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      overflow: TextOverflow.visible,
                                      "I agree terms of Service and Cancellation & Booking, Request as per terms and policies"
                                          .tr,
                                      style: textColorblack,
                                    ),
                                    if (showError &&
                                        !controller.isChecked.value)
                                      const Text(
                                        'Please agree to the terms and conditions.',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                  ],
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
      ),

      //bottomnavButton widget
      bottomNavigationBar: Obx(
        () {
          final priceDetails = hotelPriceController.priceData.value;
          final totalAmmtToBePaid = priceDetails.totalAmountToBePaid;
          final discountPrice = priceDetails.discountPrice;
          final taxService = priceDetails.taxAndServices;
          final discountPercentage = priceDetails.offerPercentage ?? '0.0';
          return hotelPriceController.loading.value
              ? const SizedBox.shrink()
              : BottomNavButton(
                  style: textBoldblack.copyWith(
                    fontSize: 17,
                  ),
                  price: "$totalAmmtToBePaid OMR",
                  buttonName: Text(
                    "confirm".tr,
                    style: const TextStyle(color: kWhite, fontSize: 15),
                  ),
                  ontap: totalAmmtToBePaid! <= 0
                      ? () {}
                      : () async {
                          setState(() {
                            showError = true;
                          });
                          try {
                            if (controller.isChecked.value) {
                              if (firstName.text.isEmpty ||
                                  lastName.text.isEmpty ||
                                  email.text.isEmpty ||
                                  phoneNumber.text.isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  duration: const Duration(seconds: 2),
                                  content: Text(
                                      "Please check the details you missed".tr),
                                  backgroundColor: darkRed,
                                ));
                                return;
                              } else {
                                // Get.to(
                                //   () => PaymentSelectionScreen(
                                //     pay: (payMethod) async {
                                // Set loading to true and show the dialog before starting the async operation
                                final guest = await guestCheckingBooking();
                                if (guest) {
                                  Get.dialog(
                                    Center(
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        elevation: 8,
                                        child: Container(
                                          width: 300, // Adjust width as needed
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Login Required'.tr,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                'login_required'.tr,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                              const SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child: Text('Cancel'.tr),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Get.back();
                                                      Get.offAll(
                                                          const LoginPage());
                                                    },
                                                    child: Text('login'.tr),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  bookingController.loading.value = true;
                                  Get.defaultDialog(
                                    barrierDismissible: false,
                                    title: "",
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const CircularProgressIndicator(
                                          color: darkRed,
                                        ),
                                        const SizedBox(height: 15),
                                        Text(
                                          "loading".tr,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: kWhite,
                                    radius: 10,
                                  );
                                  BookingData2 model = BookingData2(
                                    taxAndServices: taxService,
                                    id: data.id!.toInt(),
                                    discountPercentage: discountPercentage,
                                    promocodeApplied: promocode,
                                    bookingFname: firstName.text,
                                    bookingLname: lastName.text,
                                    bookingEmail: email.text,
                                    bookingMobileNumber:
                                        '$countryCode${phoneNumber.text}',
                                    checkinDate: datePickercontroller
                                        .getFormattedDateReverse(
                                            datePickercontroller
                                                .selectedStartDate.value),
                                    checkoutDate: datePickercontroller
                                        .getFormattedDateReverse(
                                            datePickercontroller
                                                .selectedEndDate.value),
                                    discountPrice: discountPrice!,
                                    serviceFee: 0,
                                    bookedPrice: totalAmmtToBePaid,
                                    numberOfGuests: members,
                                    children: counterControllerFind.counters[2],
                                    adults: counterControllerFind.counters[1],
                                    numberOfBookingRooms: 1,
                                    isMySelf: true,
                                    paymentType: paymentSelectionController
                                        .selectedPaymentType,
                                  );
                                  final success = await bookingController
                                      .bookingdata(model);
                                  if (success) {
                                    // Hide the dialog after successful operation
                                    Navigator.of(context).pop();
                                    bookingController.loading.value = false;
                                    Get.offAll(
                                      () => ViewMoreDetailsPage(
                                          propertyId: bookingController
                                              .bookedData.value.id
                                              .toString(),
                                          type: 'chalet'),
                                      predicate: (route) => route.isFirst,
                                    );
                                    // final hotel.BookingData bookingdata =
                                    //     hotel.BookingData(
                                    //   qrcode: bookingController
                                    //       .bookedData.value.qrcode,
                                    //   bookingNumber: bookingController
                                    //       .bookedData.value.bookingId,
                                    // );
                                    // Navigate to success page
                                    // Get.to(() => SuccessBooking(
                                    //       bookingdetails:
                                    //           hotel.BookingModel(
                                    //               data: bookingdata),
                                    //       hotelImage: data
                                    //           .chaletImages![0].imageUrl
                                    //           .toString(),
                                    //       hotelName: data.name.toString(),
                                    //       totalPrice:
                                    //           "$totalAmmtToBePaid OMR",
                                    //       mobileNumber:
                                    //           "$countryCode${phoneNumber.text}",
                                    //       selectedOption: personalController
                                    //           .currentOption
                                    //           .toString(),
                                    //       email: email.text,
                                    //       firstName: firstName.text,
                                    //       lastname: lastName.text,
                                    //       morningDays: morningDaysCount ==
                                    //                   "1" &&
                                    //               morningDaysCount == "0"
                                    //           ? day
                                    //           : morningDays,
                                    //       nightDays:
                                    //           nightdaysCount == "1" &&
                                    //                   nightdaysCount == "0"
                                    //               ? night
                                    //               : nightdays,
                                    //       checkinTime: datePickercontroller
                                    //           .getFormattedDate(
                                    //               datePickercontroller
                                    //                   .selectedStartDate
                                    //                   .value),
                                    //       checkoutTime: datePickercontroller
                                    //           .getFormattedDate(
                                    //               datePickercontroller
                                    //                   .selectedEndDate
                                    //                   .value),
                                    //       roomsAndmembers:
                                    //           "${counterControllerFind.counters[0]} ${"room".tr}, ${counterControllerFind.counters[1]} ${"adult".tr}${counterControllerFind.counters[2] >= 0 ? ', ${counterControllerFind.counters[2]} ${"children".tr}' : ''}",
                                    //     ));
                                  } else {
                                    snackbar('Failed'.tr,
                                        bookingController.message.value);
                                    bookingController.loading.value = false;
                                    Navigator.of(context)
                                        .pop(); // Hide dialog on failure
                                    // Display a failure snackbar or error message
                                  }
                                }
                                // },
                                // totalAmount:
                                // totalAmmtToBePaid.toString();
                                // ),
                                // );
                              }
                            }
                          } catch (e) {
                            bookingController.loading.value = false;
                            Navigator.of(context)
                                .pop(); // Hide dialog on exception
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  "Something went wrong! Please try again"),
                              backgroundColor: darkRed,
                            ));
                          }
                        });
        },
      ),
    );
  }
}
