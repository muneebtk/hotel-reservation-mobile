import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../constant/api_service/api_key.dart';
import '../../model/nearby_place/nearby_place_model.dart';

//nearby places of particular hotel/chalet
class ChaletNearbyControllerr extends GetxController {
  var nearbyPlaces = <Place>[].obs;
  var isLoading = false.obs;

  void fetchNearbyPlacesByCityName(LatLng latLng) async {
    isLoading(true);
    try {
      // List<Location> locations = await locationFromAddress(cityName);

      double latitude = latLng.latitude;
      double longitude = latLng.longitude;

      final placesResponse = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=2500&type=drugstore,spa,park,movie_theater,cafe,night_club,&keyword=entertainment&key=$googleApiKey'));
      if (placesResponse.statusCode == 200) {
        var jsonResponse = json.decode(placesResponse.body);
        var places = jsonResponse['results'] as List;
        nearbyPlaces.value =
            places.map((place) => Place.fromJson(place)).toList();
        if (places.isNotEmpty) {
          List<String> destinations = [];
          for (var place in places) {
            final lat = place['geometry']['location']['lat'];
            final lng = place['geometry']['location']['lng'];
            destinations.add('$lat,$lng');
          }

          final destinationsString = destinations.join('|');
          final distanceResponse = await http.get(
            Uri.parse(
                "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$latitude,$longitude&destinations=$destinationsString&key=$googleApiKey"),
          );
          print(distanceResponse.body);
          if (distanceResponse.statusCode == 200) {
            final distanceData = jsonDecode(distanceResponse.body);
            final distances = distanceData['rows'][0]['elements'];

            // Combine results
            for (int i = 0; i < places.length; i++) {
              nearbyPlaces[i].distance = distances[i]['distance']['text'];
            }
          }
        }
      } else {}
    } catch (e) {
      print(e);
      // debugPrint('Error occurred while fetching nearby places: $e');

      throw Exception("Error occurred while fetching nearby places");
    }
    isLoading(false);
  }
}
