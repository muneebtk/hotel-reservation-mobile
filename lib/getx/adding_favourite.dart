import 'dart:convert';

import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/controller/api/authentication/login_controller.dart';
import 'package:e_concierge_tourism/controller/service/compare_hotels/comparison_response.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddingCompare extends GetxController {
  var compareStates = <String>[].obs;

  void initializeCompareStates(List<String> list) {
    compareStates.value = list;
  }

  void toggle(String value) {
    if (compareStates.contains(value)) {
      compareStates.remove(value);
    } else {
      compareStates.add(value);
    }
    update();
  }
}

class CompareApiController extends GetxController {
  var loading = false.obs;
  var message = ''.obs;
  var successOrNot = false.obs;
  var failed = false.obs;
  List<ComparisonData> comparisonList = <ComparisonData>[].obs;

  Future<bool> addProperty(int id, String type) async {
    loading.value = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    final accessToken = pref.getString('access_token');
    final lang = await getLang();
    var headers = {
      'Authorization': 'Bearer $accessToken',
    };

    // if (accessToken != null && accessToken.isNotEmpty) {
    //   headers['Authorization'] = 'Bearer $accessToken';
    // }
    try {
      final uri = Uri.parse('$addToCompare$type/')
          .replace(queryParameters: {"lang": lang});
      // final newUri = uri.replace(queryParameters: {"type": type});
      final response = await http.post(
        uri,
        headers: headers,
        body: {
          "item_id": '$id',
        },
      );
      // print(response.body);
      message.value = jsonDecode(utf8.decode(response.bodyBytes))['message'] ??
          'Something went wrong'.tr;
      showAnimatedSnackBar(message.value, kBlack);
      if (response.statusCode == 201) {
        successOrNot.value = true;
        return true;
      } else {
        if (response.statusCode == 401 && accessToken != null) {
          final success = await LoginController().refToken();
          if (success) {
            return addProperty(id, type);
          }
        } else {
          successOrNot.value = false;
        }
        return false;
      }
    } catch (e) {
      successOrNot.value = false;
      return false;
    } finally {
      loading.value = false;
    }
  }

  getCompareList(String type) async {
    try {
      loading.value = true;
      failed.value = false;
      SharedPreferences pref = await SharedPreferences.getInstance();
      final accessToken = pref.getString('access_token');
      final lang = await getLang();
      var headers = {'Content-Type': 'application/json'};
      if (accessToken != null && accessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $accessToken';
      }

      final response = await http.get(
        Uri.parse('$addToCompare$type')
            .replace(queryParameters: {"lang": lang}),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final data = ComparisonModel.fromJson(
            json.decode(utf8.decode(response.bodyBytes)));
        comparisonList = data.data ?? [];
      } else {
        if (response.statusCode == 401 && accessToken != null) {
          final success = await LoginController().refToken();
          if (success) return getCompareList(type);
        } else {
          failed.value = true;
        }
      }
    } catch (e) {
      failed.value = true;
    } finally {
      loading.value = false;
    }
  }

  Future<bool> removeFromList(int id, String type) async {
    try {
      loading.value = true;
      SharedPreferences pref = await SharedPreferences.getInstance();
      final accessToken = pref.getString('access_token');
      final lang = await getLang();
      var headers = {
        'Authorization': 'Bearer $accessToken',
      };
      final response = await http.delete(
        Uri.parse('$addToCompare$type/')
            .replace(queryParameters: {"lang": lang}),
        headers: headers,
        body: {"item_id": '$id'},
      );
      message.value = jsonDecode(utf8.decode(response.bodyBytes))['message'] ??
          'Something went wrong'.tr;
      showAnimatedSnackBar(message.value, kBlack);
      if (response.statusCode == 200) {
        successOrNot.value = true;
        return true;
      } else {
        if (response.statusCode == 401 && accessToken != null) {
          final success = await LoginController().refToken();
          if (success) {
            return removeFromList(id, type);
          }
        } else {
          successOrNot.value = false;
        }
        return false;
      }
    } finally {
      loading.value = false;
    }
  }
}
