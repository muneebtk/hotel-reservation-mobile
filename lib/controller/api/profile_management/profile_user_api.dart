import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/constant/exception_message/exception_message.dart';
import 'package:e_concierge_tourism/controller/model/profile_user/profile_user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/login_controller.dart';

class ProfileUserApi extends GetxController {
  RxBool loading = false.obs;
  RxString message = "".obs;
  var userData = ProfileUserModel(
          firstname: "",
          lastname: "",
          profilepic: "",
          dateofbirth: "",
          gender: "",
          email: "",
          dialCode: "",
          countryCode: "",
          contactNumber: null)
      .obs;

  void getUserProfileData() async {
    loading.value = true;

    // Timer(const Duration(seconds: 10), () {
    //   if (loading.value) {
    //     loading.value = false;
    //     message.value = "Taking too long, please try again.";
    //     showAnimatedSnackBar(message.value, darkRed);
    //   }
    // });

    SharedPreferences pref = await SharedPreferences.getInstance();
    var accessToken = pref.getString('access_token');
    final response = await http.get(
      Uri.parse("$baseUrl/api/profile"),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    try {
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            jsonDecode(utf8.decode(response.bodyBytes));

        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> dataList = responseData['data'];

          if (dataList.isNotEmpty) {
            final Map<String, dynamic> data = dataList[0];
            ProfileUserModel fetchedDetails = ProfileUserModel.fromJson(data);
            userData.value = fetchedDetails;
          } else {
            message.value = "No data available";
          }
        } else {
          message.value = "Invalid data format";
        }
        ////
      } else {
        // debugPrint("Error ${response.statusCode}: ${response.body}");
        message.value = jsonDecode(response.body)['message'];
      }
    } catch (e) {
      debugPrint("Error parsing response: $e");
      message.value = handleHttpException(e);
      throw Exception(handleHttpException(e));
    } finally {
      loading.value = false;
    }
  }
  //* updation =====================================================================================

  Future<void> updateProfileImage(File imageFile) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accessToken = pref.getString('access_token');
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse("$baseUrl/api/profile/"),
    );

    request.headers['Authorization'] = 'Bearer $accessToken';
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      ),
    );
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        debugPrint("Image uploaded successfully: $responseBody");
      } else {
        if (response.statusCode == 401 && accessToken != null) {
          final success = await LoginController().refToken();
          if (success) {
            return updateProfileImage(imageFile);
          }
        } else {
          var responseBody = await response.stream.bytesToString();

          // print(response.statusCode);
          message.value =
              "Failed to upload image: ${response.statusCode} - $responseBody";
        }
      }

      // else {
      //   var responseBody = await response.stream.bytesToString();
      //   debugPrint(
      //       "Failed to upload image: ${response.statusCode} - $responseBody");
      // }
    } catch (e) {
      throw Exception(handleHttpException(e));
    }
  }

  //* delete image ==========================================================================================

  Future<bool> imageDelete() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accessToken = pref.getString('access_token');

    final response = await http.delete(
      Uri.parse("$baseUrl/api/profile/"),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
    try {
      if (response.statusCode == 200) {
        message.value = jsonDecode(response.body)['message'];
        return true;
      } else {
        message.value = jsonDecode(response.body)['message'];
        return false;
      }
    } catch (e) {
      throw Exception(handleHttpException(e));
    } finally {}
  }
  //*=======================================================================================================

  //edit profile

  Future<bool> putUserProfileData(ProfileUserModel2 user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accessToken = pref.getString('access_token');
    final Map<String, dynamic> updatedData = {
      'first_name': user.firstname,
      'last_name': user.lastname,
      'dob': user.dateofbirth,
      'gender': user.gender,
      'email': user.email,
      'contact_number': user.contactNumber,
      'dial_code': user.dialCode,
      'iso_code': user.countryCode
    };
    print(updatedData);
    final response = await http.put(
      Uri.parse("$baseUrl/api/profile/"),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updatedData),
    );
    // print(response.body);
    try {
      if (response.statusCode == 200) {
        debugPrint("Profile updated successfully");
        return true;
      } else {
        message.value =
            jsonDecode(response.body)['message'] ?? 'Something went wrong'.tr;
        debugPrint("Failed to update profile: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      throw Exception(handleHttpException(e));
    } finally {}
  }
}
