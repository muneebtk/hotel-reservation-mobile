import 'package:get/get.dart';

class LoadingController extends GetxController {
  var loadingvalue = false.obs;

  void loading(bool newvalue) {
    loadingvalue.value = newvalue;
  }
}
