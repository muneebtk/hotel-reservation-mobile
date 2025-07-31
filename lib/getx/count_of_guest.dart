import 'package:get/get.dart';

class CounterController extends GetxController {
  final _counters = List<int>.filled(100, 1).obs;

  List<int> get counters => _counters.toList();

  void increment(int index) {
    _counters[index]++;
  }

  void decrement(int index, bool isChildren) {
    if (isChildren) {
      if (_counters[index] >= 1) {
        _counters[index]--;
      }
    } else if (_counters[index] > 1) {
      _counters[index]--;
    }
  }
}
