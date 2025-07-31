import 'dart:convert';
import 'package:e_concierge_tourism/constant/exception_message/exception_message.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../constant/api_service/api_url.dart';
import '../../authentication/login_controller.dart';

class FavouritesApi {
  var dataList = [];
  var message = '';
  var isGuest = false;

  //* Add to favourites-----------------------------------------------------
  Future<void> addToFavourites(String hotelId, bool isLiked) async {
    Map<String, String?> tokens = await getTokens();
    String? accessToken = tokens['access_token'];

    try {
      final response = await http.post(
        Uri.parse('${favouritesApiurl}api/properties/favorites'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'hotel_id': hotelId,
          'is_liked': isLiked,
        }),
      );

      if (response.statusCode == 200) {
        await fetchFavourites();
      } else {
        message = jsonDecode(response.body)['message'] ?? 'Unknown error';
        debugPrint("Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Exception: $e");
      throw Exception(handleHttpException(e));
    }
  }

//*=======CHALETADDING FAVOURITES============================

  Future<void> addToFavouritesCHALETS(String chaletID, bool isLiked) async {
    Map<String, String?> tokens = await getTokens();
    String? accessToken = tokens['access_token'];

    try {
      final response = await http.post(
        Uri.parse(favouriteChaletUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'chalet_id': chaletID,
          'is_liked': isLiked,
        }),
      );
      if (response.statusCode == 200) {
        await fetchFavourites();
      } else {
        message = jsonDecode(response.body)['message'] ?? 'Unknown error';
        debugPrint("Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Exception: $e");
      throw Exception(handleHttpException(e));
    }
  }

  //*==== Fetch favourites============================
  Future<List<dynamic>> fetchFavourites() async {
    Map<String, String?> tokens = await getTokens();
    String? accessToken = tokens['access_token'];
    final lang = await getLang();
    isGuest = await isGuestUser();
    if (isGuest) {
      return [];
    }
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      if (accessToken != null && accessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $accessToken';
      }

      final response = await http.get(
        Uri.parse('${favouritesApiurl}api/properties/favorites')
            .replace(queryParameters: {"lang": lang}),
        headers: headers,
      );

      final chaletResponse = await http.get(
        Uri.parse(favouriteChaletUrl).replace(queryParameters: {"lang": lang}),
        headers: headers,
      );
      print(chaletResponse.body);
      if (response.statusCode == 200 || chaletResponse.statusCode == 200) {
        List<dynamic> hotelData =
            json.decode(utf8.decode(response.bodyBytes))['data'] is List
                ? json.decode(utf8.decode(response.bodyBytes))['data']
                : [];
        List<dynamic> chaletData =
            json.decode(utf8.decode(chaletResponse.bodyBytes))['data'] is List
                ? json.decode(utf8.decode(chaletResponse.bodyBytes))['data']
                : [];
        dataList = [...hotelData, ...chaletData];

        return dataList;
      } else {
        if (response.statusCode == 401 && chaletResponse.statusCode == 401) {
          debugPrint("Error: ${response.statusCode}");

          final success = await LoginController().refToken();
          if (success) {
            return await fetchFavourites();
          }
          return [];
        } else {
          debugPrint("Error: ${response.statusCode}");

          message = jsonDecode(response.body)['message'] ?? 'Unknown error';
          return [];
        }
      }
    } catch (e) {
      debugPrint("Exception: $e");
      return [];
    }
  }
  //* Remove favourite====================

  Future<void> removeFavourites(int hotelId, bool isLiked) async {
    Map<String, String?> tokens = await getTokens();
    String? accessToken = tokens['access_token'];
    try {
      final response = await http.post(
        Uri.parse('${favouritesApiurl}api/properties/favorites'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'hotel_id': hotelId,
          'is_liked': isLiked,
        }),
      );
      if (response.statusCode == 200) {
        fetchFavourites();
        debugPrint('Successfully removed');
      } else {
        message = jsonDecode(response.body)['message'];
        debugPrint("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  //*==============================================

  Future<void> removeFavouritesCHALET(int chaletID, bool isLiked) async {
    Map<String, String?> tokens = await getTokens();
    String? accessToken = tokens['access_token'];
    try {
      final response = await http.post(
        Uri.parse(favouriteChaletUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'chalet_id': chaletID,
          'is_liked': isLiked,
        }),
      );
      if (response.statusCode == 200) {
        fetchFavourites();
        debugPrint('Successfully removed');
      } else {
        message = jsonDecode(response.body)['message'];
        debugPrint("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
