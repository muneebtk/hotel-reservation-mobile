import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:e_concierge_tourism/controller/api/hotel_booking/hotel_booking_success/notf.dart';
import 'package:e_concierge_tourism/controller/api/hotel_booking/hotel_price/hotel_price_api.dart';
import 'package:e_concierge_tourism/controller/api/upcoming_section/success_details.dart';
import 'package:e_concierge_tourism/getx/booking_refund_options.dart';
import 'package:e_concierge_tourism/language/controller/transalate_controller.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:e_concierge_tourism/view/bottom_nav.dart/bottom_nav.dart';
import 'package:e_concierge_tourism/view/home/widgets/heading_text.dart';
import 'package:e_concierge_tourism/view/hotel_booking/components/bottom_nav_button.dart';
import 'package:e_concierge_tourism/getx/room_controller.dart';
import 'package:e_concierge_tourism/view/hotel_booking/reviewbooking/widgets/payment_options.dart';
import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import 'package:e_concierge_tourism/common/personal_details_widget/personal_details_widget.dart';
import 'package:e_concierge_tourism/common/promocode_widget/promocode_widget.dart';
import 'package:e_concierge_tourism/common/snackbar/snackbar.dart';
import 'package:e_concierge_tourism/common/textform/textform_field.dart';
import 'package:e_concierge_tourism/view/my_bookings/upcoming/view_more_details_page.dart';
import 'package:e_concierge_tourism/view/payment/payment_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controller/api/hotel_booking/hotel_detail/hotel_detail.dart';
import '../../../controller/api/hotel_booking/hotel_search/search_hotel_controller.dart';
import '../../../getx/checkedbox.dart';
import '../../../getx/count_of_guest.dart';
import '../../../getx/date_picker_controller.dart';
import '../../../getx/hotel_detail_controller.dart';
import '../../../getx/personal_detail_controller.dart';
import '../../../getx/remember_me.dart';
import '../../../controller/model/hotel_bookings/hotel_booking_entire/review_page_notf.dart';
import '../../auth/login_page/login_page.dart';
import '../successs_page.dart/success_booking.dart';
import 'widgets/refund_cancellation_options.dart';
import 'widgets/review_hotel.dart';
import 'widgets/room_quantity_widget.dart';

class ReviewBooking extends StatefulWidget {
  final String hotelId;
  final String hotelName;
  final String hotelImage;
  final String hotelIdsss;
  final String roomTotalPrice;
  final double countryTax;
  final List<int> roomListID;
  final List<String> roomParticularPrice;
  final int? promoId;

  // final List<int> roomOptionListID;
  final List<String> roomImage;
  const ReviewBooking({
    super.key,
    required this.countryTax,
    required this.hotelName,
    required this.hotelImage,
    required this.hotelIdsss,
    required this.roomListID,
    // required this.roomOptionListID,
    required this.roomTotalPrice,
    required this.hotelId,
    required this.roomImage,
    required this.roomParticularPrice,
    this.promoId,
  });

  @override
  State<ReviewBooking> createState() => _ReviewBookingState();
}

class _ReviewBookingState extends State<ReviewBooking> {
  //*---------------------------------------------------------------

  //getx dependency
  final LanguageController languageController = Get.find();
  final TaxNumberController taxController = Get.put(TaxNumberController());
  final PersonalDetailController controller =
      Get.put(PersonalDetailController());
  final formkey = GlobalKey<FormState>();
  final SearchHotelCityNameController roomsofParticularHotelControllers =
      Get.put(SearchHotelCityNameController());
  final NotfBooking notf = Get.put(NotfBooking());
  RoomsController roomController = Get.find();
  final DatePickerController datePickercontroller = Get.find();
  final CounterController counterControllerFind = Get.find();
  final BookingTermsAndCondition controllers =
      Get.put(BookingTermsAndCondition());
  final HotelDetailController hotelDetailcontroller =
      Get.put(HotelDetailController());
  final HotelDetailsControllerApi hotelDetailControllerApi = Get.find();
  final EmailForProfile emailController = Get.put(EmailForProfile());
  final HotelPriceApi hotelPriceController = Get.put(HotelPriceApi());
  PaymentOptionsBooking paymentSelectionController =
      Get.put(PaymentOptionsBooking());

  //textediting controller
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final firstName1 = TextEditingController();
  final lastName1 = TextEditingController();
  final email1 = TextEditingController();
  final phoneNumber2 = TextEditingController();
  double discount = 0;
  String promocode = '';
  String countryCode = '+968';
  String selectedISOCode = 'OM';
  //

  //*-----------------------------------------------------------------
  var loading = false.obs;

//calculating total number of mornings and nights that customer select
  Map<String, int> calculateRangeOfDays() {
    final checkInTime = datePickercontroller.checkInTime.value;
    final checkOutTime = datePickercontroller.checkOutTime.value;
    final startDate = datePickercontroller.selectedStartDate.value;
    final endDate = datePickercontroller.selectedEndDate.value;

    int nights = endDate.difference(startDate).inDays;

    if (endDate.day == startDate.day &&
        (checkOutTime.hour < checkInTime.hour ||
            (checkOutTime.hour == checkInTime.hour &&
                checkOutTime.minute < checkInTime.minute))) {
      nights--;
    }

    int mornings = nights + 1;

    return {'nights': nights, 'morning': mornings};
  }
  //

  late bool showError;
  bool _hasSetSavedData = false;
  String startDate = '';
  String endDate = '';

  @override
  void initState() {
    super.initState();
    getPriceDetails();
    showError = true;
  }

  getPriceDetails() {
    final List<RoomWithMeal> roomsWithMeal = roomController.roomsWithMeal;
    startDate = DateFormat('yyyy-MM-dd')
        .format(datePickercontroller.selectedStartDate.value);
    endDate = DateFormat('yyyy-MM-dd')
        .format(datePickercontroller.selectedEndDate.value);
    // const id = 38;
    hotelPriceController.getBookingPriceDetails(
        roomsWithMeal, startDate, endDate, widget.promoId,
        roomCount: counterControllerFind.counters[0],
        hotelId: int.tryParse(widget.hotelId),
        promocode: promocode);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(BookingSuccessApiDetails());
    Get.put(RoomsController());
    Get.put(RoomsControllerCheckBox());
    final roomController = Get.find<RoomsController>();
    final ApplyPromoController applyPromoController =
        Get.put(ApplyPromoController());

    //

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final nightdaysNumber = "${calculateRangeOfDays()['nights']}";
    final morningDaysNumber = "${calculateRangeOfDays()['morning']}";
    final nightdays = "${calculateRangeOfDays()['nights']} ${"nights".tr}";
    final morningDays = "${calculateRangeOfDays()['morning']} ${"days".tr}";
    final day = "${calculateRangeOfDays()['morning']} ${"day".tr}";
    final night = "${calculateRangeOfDays()['nights']} ${"night".tr}";

    //

    // int length = roomController.selectedIndexes.length;
    // double totalPrice = length * 25;
    // int nights = int.tryParse(nightdaysNumber) ?? 0;
    // double totalpriceAll = totalPrice * nights;
    // int taX = widget.countryTax.toInt();
    // double totalIncludeTax = double.parse(widget.roomTotalPrice) + taX;
    // double totalpriceTaxWithDiscount = totalIncludeTax - discount;

    //
    return Scaffold(
      appBar: MyAppBar(title: "Review Booking".tr),
      body: Obx(
        () {
          final data = hotelPriceController.priceData.value;
          final totalAmmtToBePaid = data.totalAmountToBePaid;
          double discountPrice = data.discountPrice ?? 0;
          discount = data.discountPrice ?? 0;
          final priceWithTax = data.totalRoomsPriceWithTax;
          final taxService = data.taxAndServices;
          final mealTax = data.mealTax;
          final mealPrice = data.mealPrice;
          final roomPrice =
              data.roomPriceWithMealAndNumberOfRoomsAndNumberOfDays;
          return hotelPriceController.loading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView(
                    children: [
                      Card(
                        color: Colors.white,

                        //review hotel widget
                        child: ReviewHotel(
                          propertyType: hotelDetailControllerApi
                              .hotelDetails.value.propertyType,
                          hotelRating: hotelDetailControllerApi
                              .hotelDetails.value.hotelRating,
                          hotelCityName: hotelDetailControllerApi
                              .hotelDetails.value.cityName,
                          hotelName: widget.hotelName.toUpperCase(),
                          image: widget.hotelImage,
                          morningDays: morningDaysNumber == '1' ||
                                  morningDaysNumber == '0'
                              ? day
                              : morningDays,
                          nightDays:
                              nightdaysNumber == '1' || nightdaysNumber == '0'
                                  ? night
                                  : nightdays,
                          width: width,
                          height: height,
                          checkIndate: datePickercontroller.getFormattedDate(
                              datePickercontroller.selectedStartDate.value),
                          checkoutdate: datePickercontroller.getFormattedDate(
                              datePickercontroller.selectedEndDate.value),
                          guestInfo:
                              "${counterControllerFind.counters[0]} ${"room".tr}, ${counterControllerFind.counters[1]} ${"adult".tr}${counterControllerFind.counters[2] >= 0 ? ', ${counterControllerFind.counters[2]} ${"children".tr}' : ''}",
                        ),
                      ),

                      //customer selected room showing widget
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 1,
                        // itemCount: roomController.roomsWithMeal.length,
                        itemBuilder: (context, index) => RoomsQuantityWidget(
                          nights: null,
                          index: index,
                          roomImage: widget.roomImage.isNotEmpty
                              ? widget.roomImage[index]
                              : '',
                          codeNumCompleted: "2",
                          width: width,
                          roomName:
                              roomController.roomsWithMeal[index].roomName,
                          roomDescription:
                              roomController.roomsWithMeal[index].meal.tr,
                        ),
                      ),
                      const Divider(),

                      //refund policy widget for payment
                      // RefundCancellationPolicy(
                      //   cancellationPolicy: hotelDetailControllerApi
                      //       .hotelDetails.value.cancellationPolicy,
                      // ),
                      if (data.acceptedPayments != null &&
                          data.acceptedPayments!.isNotEmpty)
                        //payment option type
                        PaymentOptions(
                          acceptedPayments: data.acceptedPayments!,
                        ),

                      //personal details of customer
                      Obx(() {
                        final data = emailController;
                        List<String> options = ["Myself", "Someone Else"];
                        if (emailController.userName.isNotEmpty &&
                            data.lastName.isNotEmpty &&
                            data.email.isNotEmpty &&
                            controller.currentOption.value == "Myself" &&
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
                          phoneNumber.text = emailController.phoneNumber.value;
                          _hasSetSavedData = true;
                        } else {
                          if (data.userName.value.isNotEmpty &&
                              controller.currentOption.value ==
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
                                  padding:
                                      const EdgeInsets.only(left: 15, top: 15),
                                  child: HeadingText(
                                      heading: "I am booking for".tr),
                                ),
                                Row(
                                  children: [
                                    Radio(
                                      fillColor:
                                          const WidgetStatePropertyAll(darkRed),
                                      value: options[0],
                                      groupValue:
                                          controller.currentOption.value,
                                      onChanged: (value) {
                                        controller
                                            .changeOption(value.toString());
                                      },
                                    ),
                                    Text("myself".tr, style: textBoldblack),
                                    width10,
                                    Radio(
                                      fillColor:
                                          const WidgetStatePropertyAll(darkRed),
                                      value: options[1],
                                      groupValue:
                                          controller.currentOption.value,
                                      onChanged: (value) {
                                        controller
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
                                              keyboardType: TextInputType.name,
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
                                              keyboardType: TextInputType.name,
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
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      height10,
                                      SizedBox(
                                        height: 90,
                                        child: IntlPhoneField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          pickerDialogStyle: PickerDialogStyle(
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
                                            // contentPadding: EdgeInsets.symmetric(
                                            //     vertical: 18.0, horizontal: 10),
                                            fillColor: kWhite,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(),
                                            ),
                                          ),
                                          languageCode: languageController
                                                      .selectedLanguage.value ==
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
                                                overflow: TextOverflow.visible,
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
                        isApplied: data.isPromocodeApplied,
                        applyCode: (model) async {
                          if (model != null) {
                            model.checkinDate = startDate;
                            model.checkoutDate = endDate;
                            // final re = await applyPromoController
                            //     .applyPromocode(model);
                            // if (re != null) {
                            //   if (priceWithTax != null && priceWithTax > 0) {
                            //     hotelPriceController
                            //         .priceData.value.totalAmountToBePaid = re;
                            //     hotelPriceController
                            //             .priceData.value.discountPrice =
                            //         double.parse(
                            //             (priceWithTax - re).toStringAsFixed(2));
                            //   }
                            promocode = model.promocode ?? '';
                            getPriceDetails();

                            // }
                          } else {
                            discount = 0;
                          }
                          setState(() {});
                        },
                        clear: () {
                          promocode = '';
                          getPriceDetails();
                        },
                      ),

                      //price section / tax/ base price/ total amount

                      Card(
                        elevation: 4,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Obx(
                            () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("price_break_up".tr),
                                height10,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "${counterControllerFind.counters[0]} ${"room".tr} * $nightdays\n ${'base_price'.tr}"),
                                    Text("$roomPrice OMR")
                                    // Obx(
                                    //   () {
                                    //     roomController.selectedIndexes.length;

                                    //     return Text(totalPrice
                                    //             .toString()
                                    //             .isEmpty
                                    //         ? ""
                                    //         : "${widget.roomTotalPrice} OMR");
                                    //   },
                                    // ),
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
                                if (mealPrice != null && mealPrice > 0) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("meal_price".tr),
                                      Text("$mealPrice OMR"),
                                    ],
                                  ),
                                  const Divider(),
                                ],
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
                                if (discountPrice > 0) ...[
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Discount Price".tr,
                                          style: const TextStyle()),
                                      Text(" - $discountPrice OMR"),
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
                                    Text("${totalAmmtToBePaid.toString()} OMR",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Checkbox(
                              fillColor:
                                  const WidgetStatePropertyAll(lightgrey),
                              activeColor: Colors.white,
                              checkColor: Colors.black,
                              value: controllers.isChecked.value,
                              onChanged: (newValue) {
                                controllers.isChecked.value = newValue!;
                              },
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      launchUrl(Uri.parse(privacyPolicy));
                                    },
                                    child: Text(
                                      "i_agree_terms_service_cancellation_booking"
                                          .tr,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  if (showError && !controllers.isChecked.value)
                                    Text(
                                      'Please_agree_to_the_terms_and_conditions'
                                          .tr,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),

      //booking final completing button
      bottomNavigationBar: Obx(
        () {
          final data = hotelPriceController.priceData.value;
          final totalAmmtToBePaid = data.totalAmountToBePaid;
          final taxService = data.taxAndServices ?? 0.0;
          final mealTax = data.mealTax ?? 0.0;
          final mealPrice = data.mealPrice ?? 0.0;
          final discountPercentage = data.offerPercentage ?? '0.0';
          if (hotelPriceController.loading.value) {
            return const SizedBox.shrink();
          }
          return BottomNavButton(
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            price: "$totalAmmtToBePaid OMR",
            buttonName: Text(
              "continue".tr,
              style: const TextStyle(color: kWhite),
            ),
            ontap: totalAmmtToBePaid! <= 0
                ? () {}
                : () async {
                    if (firstName.text.isEmpty ||
                        lastName.text.isEmail ||
                        email.text.isEmpty ||
                        phoneNumber.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 2),
                        content: Text("Pls check the detail you missed".tr),
                        backgroundColor: darkRed,
                      ));
                    }
                    if (controllers.isChecked.value &&
                        firstName.text.isNotEmpty &&
                        lastName.text.isNotEmpty &&
                        email.text.isNotEmpty &&
                        phoneNumber.text.isNotEmpty) {
                      try {
                        final guest = await guestCheckingBooking();
                        if (guest) {
                          loginPrompt();
                        }

                        // Get.to(
                        // () => PaymentSelectionScreen(
                        //   totalAmount: totalAmmtToBePaid.toString(),
                        //   pay: (payMethod) async {
                        //loading diologue
                        if (guest == false) {
                          loading.value = true;
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

                          final success = await bookingNof(
                              totalAmmtToBePaid,
                              discountPercentage,
                              taxService,
                              mealPrice,
                              mealTax);
                          Navigator.of(context, rootNavigator: true).pop();

                          if (success != null) {
                            Get.offAll(
                              () => ViewMoreDetailsPage(
                                  propertyId: success, type: 'hotel'),
                              predicate: (route) => route.isFirst,
                            );
                            //navigating success page after booking payment success

                            // Get.off(() => SuccessBooking(
                            //       bookingdetails: success,
                            //       hotelImage: widget.hotelImage,
                            //       hotelName: widget.hotelName,
                            //       totalPrice: "$totalAmmtToBePaid OMR",
                            //       mobileNumber: phoneNumber.text,
                            //       selectedOption:
                            //           controller.selectedValue.value,
                            //       email: email.text,
                            //       firstName: firstName.text,
                            //       lastname: lastName.text,
                            // morningDays: morningDaysNumber == '1' ||
                            //         morningDaysNumber == '0'
                            //     ? day
                            //     : morningDays,
                            //       nightDays: nightdaysNumber == '1' ||
                            //               nightdaysNumber == '0'
                            //           ? night
                            //           : nightdays,
                            //       checkinTime: datePickercontroller
                            //           .getFormattedDate(
                            //               datePickercontroller
                            //                   .selectedStartDate.value),
                            //       checkoutTime: datePickercontroller
                            //           .getFormattedDate(
                            //               datePickercontroller
                            //                   .selectedEndDate.value),
                            //       roomsAndmembers:
                            //           "${roomController.roomIndexMap.length} ${"room".tr}, ${counterControllerFind.counters[1]} ${"adult".tr}${counterControllerFind.counters[2] >= 0 ? ', ${counterControllerFind.counters[2]} ${"children".tr}' : ''}",
                            // ));
                            // }
                          }
                        }
                        // ),
                        // );
                        //   //   Get.snackbar("Booking Hotel Failed", 'Please try again');
                      } catch (e) {
                        Navigator.of(context, rootNavigator: true).pop();
                        // debugPrint("Failed, Please Try again $e");
                        Get.snackbar(
                            "Booking Failed".tr, 'Please try again'.tr);
                      } finally {
                        loading.value = false;
                      }
                    } else {
                      //Get.snackbar("Failed", 'Please select terms and conditions');
                    }
                  },
          );
        },
      ),
    );
  }

// customer booking details all data sending to server -----

  Future<String?> bookingNof(
      double totalPriceIncludeTax,
      String discountPercentage,
      double tax,
      double mealPrice,
      double mealTax) async {
    final List<RoomWithMeal> roomsWithMeal = roomController.roomsWithMeal;
    List<RoomParticularPrice> roomPriceList =
        widget.roomListID.asMap().entries.map((entry) {
      int index = entry.key;
      int roomId = entry.value;
      String roomPriceParticular = widget.roomParticularPrice[index];
      final roomIndex = roomsWithMeal.indexWhere((e) => e.roomId == roomId);
      return RoomParticularPrice(
        roomPriceParticular: roomPriceParticular,
        roomIdList: roomId,
        mealId: roomsWithMeal[roomIndex].mealTypeId,
      );
    }).toList();
    BookingModelNotf model = BookingModelNotf(
        taxAndServices: tax,
        mealPrice: mealPrice,
        mealTax: mealTax,
        discountPercentage: discountPercentage,
        promocodeApplied: promocode,
        checkingDate: datePickercontroller.getFormattedDateReverse(
            datePickercontroller.selectedStartDate.value),
        checkoutDate: datePickercontroller.getFormattedDateReverse(
            datePickercontroller.selectedEndDate.value),
        members: counterControllerFind.counters[1] +
            counterControllerFind.counters[2],
        children: counterControllerFind.counters[2],
        adults: counterControllerFind.counters[1],
        rooms: counterControllerFind.counters[0],
        room: roomPriceList,
        // roomOptionsId: widget.roomOptionListID,
        isMySelf: true,
        bookingFname: firstName.text,
        bookingLname: lastName.text,
        bookingEmail: email.text,
        bookingMobileNumber: "$countryCode${phoneNumber.text}",
        totalAmount: totalPriceIncludeTax,
        discount: discount,
        serviceFee: 0,
        paymentType: paymentSelectionController.selectedPaymentType,
        count: counterControllerFind.counters[0]);

    try {
      //data sending to the api
      print(model.toJson());
      final success = await notf.notf(model, widget.hotelIdsss);

      if (success != null) {
        return success;
      } else {
        snackbar('Failed'.tr, notf.message.value);
      }
    } catch (e) {
      snackbar('Error', e.toString());
    }

    return null;
  }
}
