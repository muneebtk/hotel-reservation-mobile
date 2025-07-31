import 'dart:developer';

import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/getx/dropdown_chalet_property.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constant/api_service/api_key.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CitySearchDelegate extends SearchDelegate<String> {
  final SearchCityController searchCityController = Get.find();
  final SearchLocationController searchLocationController = Get.find();
  final PropertyTypeController propertySelect = Get.find();
  @override
  String get searchFieldLabel => 'Search cities'.tr;

  @override
  TextStyle get searchFieldStyle => const TextStyle(
        color: Colors.black87,
        fontSize: 16,
      );
  List<String> recentCities = [];
  List<String> recentIds = [];

  CitySearchDelegate() {
    _loadRecentCities();
  }

  Future<void> _loadRecentCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    recentCities = prefs.getStringList('recentCities') ?? [];
    recentIds = prefs.getStringList('recentIds') ?? [];
  }

  Future<void> _saveRecentCity(String city, String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!recentCities.contains(city)) {
      if (recentCities.length >= 5) {
        recentCities.removeAt(0);
        recentIds.removeAt(0);
      }
      recentCities.add(city);
      recentIds.add(id);
      await prefs.setStringList('recentIds', recentIds);
      await prefs.setStringList('recentCities', recentCities);
    }
  }

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
      return _buildRecentCities();
    }

    searchCityController.getSuggestions(query);
    return Obx(() {
      if (searchCityController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (searchCityController.hasError.value) {
        return Center(
            child: Text(
                '${"Something went wrong".tr}'));
      } else if (searchCityController.suggestions.isEmpty) {
        return Center(child: Text('City not available'.tr));
      } else {
        return ListView.builder(
          itemCount: searchCityController.suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = searchCityController.suggestions[index];
            return InkWell(
              onTap: () {
                searchLocationController.selectedId.value =
                    suggestion["placeId"] ?? '';
                close(context, suggestion["description"]!);
                propertySelect.searchCityController.value =
                    suggestion["main_text"]!;
                propertySelect.cityId.value = suggestion["placeId"] ?? '';
                _saveRecentCity(
                    suggestion["main_text"]!, suggestion["placeId"] ?? '');
              },
              child: _buildSuggestionTile(suggestion),
            );
          },
        );
      }
    });
  }

  Widget _buildRecentCities() {
    return ListView.builder(
      itemCount: recentCities.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.history),
          title: Text(recentCities[index]),
          onTap: () {
            close(context, recentCities[index]);
            propertySelect.searchCityController.value = recentCities[index];
            // _saveRecentCity(recentCities[index], recentIds[index]);
            searchLocationController.selectedId.value = recentIds[index];
            print('save id ${recentIds[index]}');
          },
        );
      },
    );
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
          Expanded(
            child: Column(
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
                  overflow: TextOverflow.visible,
                  suggestion["secondary_text"]!,
                  style: const TextStyle(color: kGrey),
                ),
              ],
            ),
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

class SearchCityController extends GetxController {
  final SearchLocationController searchLocationController = Get.find();

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
          print(prediction);
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
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}

class SearchLocationController extends GetxController {
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
  final SearchLocationController controller = Get.find();
  Future<void> onChange(String input) async {
    controller.detectedLanguage.value = detectInputLanguage(input);
    try {
      String baseUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json";
      String request =
          "$baseUrl?input=$input&key=$googleApiKey&sessiontoken=${controller.sessionToken.value}types=(cities|establishment)&language=${controller.detectedLanguage.value}";    
      http.Response response = await http.get(Uri.parse(request));
    print(response.body);
      if (response.statusCode == 200) {
        log(response.body);
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

Future<Map<String,dynamic>?> getLocationAddress(String placeId) async {
  try {
    String baseUrl = 'https://maps.googleapis.com/maps/api/place/details/json';
    String request = "$baseUrl?place_id=$placeId&language=en&key=$googleApiKey";
    http.Response response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      log('hi ${jsonDecode(response.body)['result']}');
      final data = jsonDecode(response.body)['result']['geometry'];
      if (data != null) {
        return data['location'];
      }
    } else {
      throw Exception("There is an error".tr);
    }
  } catch (e) {}
  return null;
}

String detectInputLanguage(String input) {
  final arabicPattern = RegExp(r'[\u0600-\u06FF]');
  final englishPattern = RegExp(r'[a-zA-Z]');

  if (arabicPattern.hasMatch(input)) {
    return 'ar';
  } else if (englishPattern.hasMatch(input)) {
    return 'en';
  } else {
    return 'en';
  }
}
