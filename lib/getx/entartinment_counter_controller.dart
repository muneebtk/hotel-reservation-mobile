import 'package:get/get.dart';

class CounterControllerEntertainment extends GetxController {
  RxInt personCount = 1.obs;
  RxInt childCount = 1.obs;

  void increment(int index) {
    if (personCount.value > 0) {
      personCount.value++;
    }
  }

  void decrement(int index) {
    if (personCount.value > 1) {
      personCount.value--;
    }
  }

  void incrementChild(int index) {
    if (childCount.value > 0) {
      childCount.value++;
    }
  }

  void decrementChild(int index) {
    if (childCount.value > 1) {
      childCount.value--;
    }
  }
}
