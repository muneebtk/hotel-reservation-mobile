import 'package:get/get.dart';

class BookingRefundOptions extends GetxController {
  // final PaymentOptionsBooking controller = Get.put(PaymentOptionsBooking());
  var currentOption = "Get full fare refund on cancellation".obs;

  void changeOption(String newOption) {
    currentOption.value = newOption;
  }
}

class PaymentOptionsBooking extends GetxController {
  var currentOptions = "Pay Online\n".obs;
  var selectedPaymentType = 'Online';

  void changePaymentOption(String newOption) {
    currentOptions.value = newOption;
    if (currentOptions.value == 'Pay Online\n'.tr) {
      selectedPaymentType = 'Online';
    } else if (currentOptions.value == 'Pay Offline\n'.tr) {
      selectedPaymentType = 'Offline';
    }
  }
}
