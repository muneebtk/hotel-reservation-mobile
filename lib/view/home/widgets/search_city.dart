import 'package:e_concierge_tourism/common/google_search_api/google_search_api.dart';
import 'package:e_concierge_tourism/getx/count_of_guest.dart';
import 'package:e_concierge_tourism/getx/date_picker_controller.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/getx/dropdown_chalet_property.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/view/hotel_booking/hotel_list/hotel_ilst.dart';
import 'package:e_concierge_tourism/view/hotel_booking/personal_detail/widgets/gender_selection.dart';
import 'package:e_concierge_tourism/common/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../constant/api_service/api_key.dart';
import '../../../controller/api/chalets_booking/chalet_list_and_detail/chalet_search_api.dart';
import '../../../controller/api/hotel_booking/hotel_search/search_hotel_controller.dart';
import '../../../controller/model/chalet_bookings/chalet_booking_entire/chalet_searching.dart';
import '../../../controller/model/hotel_bookings/hotel_booking_entire/search_hotels_model.dart';
import '../../chalets_booking/chalet_list/chalet_list.dart';

class CitySearchDelegateHome extends SearchDelegate<String> {
  final SearchCityControllerHome searchCityController = Get.find();
  final PropertyTypeController propertySelect = Get.find();
  final CounterController counter = Get.put(CounterController());
  final DatePickerController datePickercontroller =
      Get.put(DatePickerController());
  final SearchLocationController searchLocationController = Get.find();
  final SearchHotelCityNameController searchHotelCityController =
      Get.put(SearchHotelCityNameController());
  final ChaletSearchApi chaletSearchApiController = Get.put(ChaletSearchApi());
  String city = '';
  @override
  String get searchFieldLabel => 'Search cities'.tr;
  final RxString selectedOption = "Hotel".obs;

  @override
  TextStyle get searchFieldStyle => const TextStyle(
        color: Colors.black87,
        fontSize: 16,
      );
  List<String> recentCities = [];
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return theme.copyWith(
      appBarTheme: AppBarTheme.of(context).copyWith(
        backgroundColor: colorScheme.brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white,
        iconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      ),
      inputDecorationTheme: searchFieldDecorationTheme ??
          const InputDecorationTheme(
            hintStyle: TextStyle(fontSize: 17),
            border: InputBorder.none,
          ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(17.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: GenderSelectionWidget(
                    selectedOption: selectedOption, option: 'Hotel'.tr)),
            width15,
            Expanded(
                child: GenderSelectionWidget(
                    selectedOption: selectedOption, option: 'Chalet'.tr)),
            width15,
          ],
        ),
      );
    }

    searchCityController.getSuggestions(query);
    return Obx(() {
      if (searchCityController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (searchCityController.hasError.value) {
        return Center(
            child: Text(
                '${"Error".tr}: ${searchCityController.errorMessage.value}'));
      } else if (searchCityController.suggestions.isEmpty) {
        return Center(child: Text('City not available'.tr));
      } else {
        return ListView.builder(
          itemCount: searchCityController.suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = searchCityController.suggestions[index];
            return InkWell(
              onTap: () async {
                // print('hello');

                close(context, suggestion["description"]!);
                propertySelect.searchCityController.value =
                    suggestion["main_text"]!;
                //_saveRecentCity(suggestion["main_text"]!);
              },
              child: InkWell(
                  onTap: () async {
                    double? lat, lng;

                    city = suggestion["main_text"]!;
                    searchLocationController.selectedId.value =
                        suggestion["placeId"] ?? '';
                    final id = searchLocationController.selectedId.value;
                    final lang =
                        searchLocationController.detectedLanguage.value;
                    // print(city);
                    // if (detectInputLanguage(city) == 'ar') {
                      final responseCity = await getLocationAddress(id);
                      // print(responseCity);

                      if (responseCity != null) {
                        // print('hello');
                        // city = responseCity;
                        lat = responseCity['lat'];
                        lng = responseCity['lng'];
                      }
                    // }
                    final SearchHotelCityNameModel datas =
                        SearchHotelCityNameModel(
                      lat: lat,
                      lng: lng,
                      priceRangeSort: [],
                      filter: {
                        "amenities": ["pool", "gym"],
                        "rating": [4, 5],
                      },
                      sorted: 'Recommended',
                      hotelName: "",
                      cityName: city,
                      checkingDate:
                          datePickercontroller.getFormattedDateReverse(
                              datePickercontroller.selectedStartDate.value),
                      checkoutDate:
                          datePickercontroller.getFormattedDateReverse(
                              datePickercontroller.selectedEndDate.value),
                      members: counter.counters[0],
                      room: counter.counters[1],
                    );
//----------------------------------------------------------------

                    ChaletSearchRequestModel model1 = ChaletSearchRequestModel(
                      lat: lat,
                      lng: lng,
                      amenities: [],
                      sorted: 'lowest_price',
                      rating: 0,
                      adults: 2,
                      children: 2,
                      // filter: {
                      //   "price": [],
                      //   "location": [],
                      // },
                      cityName: city,
                      checkinDate: datePickercontroller.getFormattedDateReverse(
                          datePickercontroller.selectedStartDate.value),
                      checkoutDate:
                          datePickercontroller.getFormattedDateReverse(
                              datePickercontroller.selectedEndDate.value),
                    );
                    //    ChaletModel model1 = ChaletModel();
//----------------------------------------------------------------

                    try {
                      if (selectedOption.value == "Hotel") {
                        bool success =
                            await searchHotelCityController.fetchData(datas);
                        if (success) {
                          Get.to(() => HotelList(
                            cityLatLng: (lat !=null && lng != null) ? LatLng(lat, lng):  null,
                                searchData: datas,
                                index: index,
                                hotelName: "",
                                cityName: suggestion["main_text"]!,
                                checkingDate: datePickercontroller
                                    .getFormattedDateReverse(
                                        datePickercontroller
                                            .selectedStartDate.value),
                                checkoutDate: datePickercontroller
                                    .getFormattedDateReverse(
                                        datePickercontroller
                                            .selectedEndDate.value),
                                members: counter.counters[0],
                                room: counter.counters[1],
                              ));
                        } else {
                          snackbar("Failed",
                              searchHotelCityController.errormessage.value);
                        }
                      } else {
                        bool success = await chaletSearchApiController
                            .fetchChalets(model1);
                        if (success) {
                          Get.to(() => ChaletListPage(
                            cityLatLng: (lat !=null && lng != null) ? LatLng(lat, lng):  null,
                                city: suggestion["main_text"]!,
                              ));
                        } else {
                          Get.snackbar(
                              "Oops!", chaletSearchApiController.message.value,
                              backgroundColor: darkRed, colorText: kWhite);
                        }
                      }
                    } catch (e) {
                      snackbar("Something went wrong".tr, e.toString());
                    }
                  },
                  child: _buildSuggestionTile(suggestion)),
            );
          },
        );
      }
    });
  }

  Widget _buildSuggestionTile(Map<String, String> suggestion) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: darkRed),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                suggestion["main_text"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                suggestion["secondary_text"]!,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(query),
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }
}

class SearchCityControllerHome extends GetxController {
  final SearchLocationControllerHome searchLocationController = Get.find();

  var suggestions = <Map<String, String>>[].obs;

  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  void getSuggestions(String query) async {
    if (query.isEmpty) {
      suggestions.clear();
      return;
    }

    isLoading.value = true;
    hasError.value = false;

    try {
      await SearchLocationFunction().onChange(query);
      suggestions.value = List<Map<String, String>>.from(
        searchLocationController.data.map((prediction) {
          return {
            "main_text":
                prediction["structured_formatting"]["main_text"].toString(),
            "secondary_text": prediction["structured_formatting"]
                    ["secondary_text"]
                .toString(),
            "description": prediction["description"].toString(),
            "placeId": prediction["place_id"].toString()
          };
        }),
      );
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

class SearchLocationControllerHome extends GetxController {
  var sessionToken = "".obs;
  var data = [].obs;
  var detectedLanguage = 'en'.obs;
  var selectedId = ''.obs;

  void setSessionToken(String token) {
    sessionToken.value = token;
  }

  void setData(List<dynamic> newData) {
    data.value = newData;
  }
}

class SearchLocationFunction {
  final SearchLocationControllerHome controller = Get.find();
  Future<void> onChange(String input) async {
    controller.detectedLanguage.value = detectInputLanguage(input);
    try {
      String baseUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json";
      String request =
          "$baseUrl?input=$input&key=$googleApiKey&sessiontoken=${controller.sessionToken.value}&types=(cities)&language=${controller.detectedLanguage.value}";
      http.Response response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        controller.setData(jsonDecode(response.body)["predictions"]);
      } else {
        throw Exception("There is an error".tr);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
