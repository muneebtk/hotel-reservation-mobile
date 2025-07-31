import 'package:dotted_border/dotted_border.dart';
import 'package:e_concierge_tourism/common/button/button.dart';
import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import 'package:e_concierge_tourism/common/enum/payment_charges.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/controller/api/payment_accepted_check/payment_types_check.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/booking_price_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PaymentSelectionScreen extends StatefulWidget {
  const PaymentSelectionScreen({
    super.key,
    required this.pay,
    required this.totalAmount,
    required this.propertyType,
    required this.id,
  });
  final Function(String) pay;
  final String totalAmount;
  final String propertyType;
  final int id;

  @override
  State<PaymentSelectionScreen> createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  final PaymentTypesCheck paymentTypesCheckController =
      Get.put(PaymentTypesCheck());
  String selectedMethod = 'WALLET'.tr;

  RxString totalAmmtToBePaid = ''.obs;

  @override
  void initState() {
    totalAmmtToBePaid.value = widget.totalAmount;
    paymentTypesCheckController.checkPaymentTypesAccepted(
        widget.id, widget.propertyType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Payment".tr),
      body: Obx(() {
        final data = paymentTypesCheckController.paymentMethodsAccepted;
        if (paymentTypesCheckController.loading.value ||
            data == null ||
            data.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: DottedBorder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                color: darkRed,
                dashPattern: const [5, 3],
                strokeWidth: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "total_amount_to_be_paid".tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Obx(() {
                      return Text(
                        "${totalAmmtToBePaid.value} OMR",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                "Select Payment Method".tr,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            ...List.generate(data.length, (index) {
              return Container(
                margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                decoration: BoxDecoration(
                  color: lightGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: RadioListTile(
                  // secondary: Image.asset(
                  //   paymentTypeIcons(data[index].category ?? ''),
                  //   // scale: 2.5,
                  // ),
                  activeColor: darkRed,
                  // controlAffinity: ListTileControlAffinity.trailing,
                  secondary: Text(
                    data[index].category ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),
                  value: data[index].category ?? '',
                  groupValue: selectedMethod,
                  onChanged: (v) {
                    // totalAmount(1.5);
                    if (v != null) {
                      setState(() {
                        selectedMethod = v;
                        // print(selectedMethod);
                      });
                    }
                  },
                ),
              );
            }),
            // Container(
            //   margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            //   decoration: BoxDecoration(
            //     color: lightGrey,
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: RadioListTile(
            //     secondary: Image.asset(
            //       'assets/images/card.png',
            //       scale: 2.5,
            //     ),
            //     activeColor: darkRed,
            //     controlAffinity: ListTileControlAffinity.trailing,
            //     title: Text('Online'.tr),
            //     value: 'Online',
            //     groupValue: selectedMethod,
            //     onChanged: (v) {
            //       totalAmount(1.5);
            //       setState(() {
            //         selectedMethod = v!;
            //       });
            //     },
            //   ),
            // ),
            // Container(
            //   margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            //   decoration: BoxDecoration(
            //     color: lightGrey,
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: RadioListTile(
            //     secondary: Image.asset(
            //       'assets/images/card.png',
            //       scale: 2.5,
            //     ),
            //     activeColor: darkRed,
            //     controlAffinity: ListTileControlAffinity.trailing,
            //     title: Text('Cash'.tr),
            //     value: 'Cash',
            //     groupValue: selectedMethod,
            //     onChanged: (v) {
            //       totalAmount(2.5);
            //       setState(() {
            //         selectedMethod = v!;
            //       });
            //     },
            //   ),
            // ),
            // Container(
            //   margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            //   decoration: BoxDecoration(
            //     color: lightGrey,
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: RadioListTile(
            //     secondary: const Icon(Icons.wallet),
            //     activeColor: darkRed,
            //     controlAffinity: ListTileControlAffinity.trailing,
            //     title: Text('Wallet'.tr),
            //     value: 'Wallet',
            //     groupValue: selectedMethod,
            //     onChanged: (v) {
            //       totalAmount(0);
            //       setState(() {
            //         selectedMethod = v!;
            //       });
            //     },
            //   ),
            // ),
            // if (selectedMethod != 'Wallet')
            //   Padding(
            //     padding: const EdgeInsets.all(15),
            //     child: Form(
            //       key: _formKey,
            //       autovalidateMode: AutovalidateMode.onUserInteraction,
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           const Text(
            //             'Enter Card Details',
            //             style: TextStyle(fontWeight: FontWeight.w500),
            //           ),
            //           height10,
            //           const Text('Name'),
            //           TextFormField(
            //             forceErrorText: null,
            //             controller: nameController,
            //             validator: (value) {
            //               if (value == null || value.isEmpty) {
            //                 return 'Please enter card holder name';
            //               }
            //               return null;
            //             },
            //             decoration: InputDecoration(
            //                 contentPadding:
            //                     const EdgeInsets.symmetric(horizontal: 10),
            //                 hintText: 'Enter card holder name',
            //                 hintStyle: const TextStyle(fontSize: 14),
            //                 border: OutlineInputBorder(
            //                   borderRadius: BorderRadius.circular(10.0),
            //                   borderSide: const BorderSide(
            //                     width: 0,
            //                     style: BorderStyle.none,
            //                   ),
            //                 ),
            //                 filled: true,
            //                 fillColor: lightGrey),
            //           ),
            //           height10,
            //           const Row(
            //             children: [
            //               Expanded(child: Text('CVV')),
            //               width10,
            //               Expanded(child: Text('Expiry Date'))
            //             ],
            //           ),
            //           Row(
            //             children: [
            //               Expanded(
            //                 child: TextFormField(
            //                   forceErrorText: null,
            //                   controller: cvvController,
            //                   keyboardType: TextInputType.number,
            //                   inputFormatters: <TextInputFormatter>[
            //                     FilteringTextInputFormatter.digitsOnly,
            //                     LengthLimitingTextInputFormatter(3),
            //                   ],
            //                   validator: (value) {
            //                     if (value == null || value.isEmpty) {
            //                       return 'Please enter cvv';
            //                     }
            //                     return null;
            //                   },
            //                   decoration: InputDecoration(
            //                       contentPadding: const EdgeInsets.symmetric(
            //                           horizontal: 10),
            //                       hintText: 'CCV code',
            //                       hintStyle: const TextStyle(fontSize: 14),
            //                       border: OutlineInputBorder(
            //                         borderRadius: BorderRadius.circular(10.0),
            //                         borderSide: const BorderSide(
            //                           width: 0,
            //                           style: BorderStyle.none,
            //                         ),
            //                       ),
            //                       filled: true,
            //                       fillColor: lightGrey),
            //                 ),
            //               ),
            //               width10,
            //               Expanded(
            //                 child: TextFormField(
            //                   forceErrorText: null,
            //                   controller: dateController,
            //                   // keyboardType: TextInputType.number,
            //                   // inputFormatters: <TextInputFormatter>[
            //                   //   FilteringTextInputFormatter.digitsOnly
            //                   // ],
            //                   validator: (value) {
            //                     if (value == null || value.isEmpty) {
            //                       return 'Please enter expiry date';
            //                     }
            //                     return null;
            //                   },
            //                   decoration: InputDecoration(
            //                       contentPadding: const EdgeInsets.symmetric(
            //                           horizontal: 10),
            //                       hintText: 'MM/YY',
            //                       hintStyle: const TextStyle(fontSize: 14),
            //                       border: OutlineInputBorder(
            //                         borderRadius: BorderRadius.circular(10.0),
            //                         borderSide: const BorderSide(
            //                           width: 0,
            //                           style: BorderStyle.none,
            //                         ),
            //                       ),
            //                       filled: true,
            //                       fillColor: lightGrey),
            //                 ),
            //               ),
            //             ],
            //           ),
            //           height10,
            //           const Text('Card Number'),
            //           TextFormField(
            //             forceErrorText: null,
            //             controller: numberController,
            //             keyboardType: TextInputType.number,
            //             inputFormatters: <TextInputFormatter>[
            //               FilteringTextInputFormatter.digitsOnly,
            //               LengthLimitingTextInputFormatter(16),
            //             ],
            //             validator: (value) {
            //               if (value == null || value.isEmpty) {
            //                 return 'Please enter $selectedMethod number';
            //               }
            //               return null;
            //             },
            //             decoration: InputDecoration(
            //                 contentPadding:
            //                     const EdgeInsets.symmetric(horizontal: 10),
            //                 hintText:
            //                     'Enter your 16-digit $selectedMethod number',
            //                 hintStyle: const TextStyle(fontSize: 14),
            //                 border: OutlineInputBorder(
            //                   borderRadius: BorderRadius.circular(10.0),
            //                   borderSide: const BorderSide(
            //                     width: 0,
            //                     style: BorderStyle.none,
            //                   ),
            //                 ),
            //                 filled: true,
            //                 fillColor: lightGrey),
            //           ),
            //         ],
            //       ),
            //     ),
            //   )
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (!paymentTypesCheckController.loading.value &&
            paymentTypesCheckController.paymentMethodsAccepted != null &&
            paymentTypesCheckController.paymentMethodsAccepted!.isNotEmpty) {
          return Container(
            height: 90,
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 25),
            child: ButtonWidget(
              ontap: () {
                // print(selectedMethod == 'WALLET'.tr);
                final selectedType = setSelectType(selectedMethod);
                // print(selectedType);
                print(selectedMethod);
                widget.pay(selectedType);
              },
              text: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'pay now'.tr,
                    style: const TextStyle(color: kWhite),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  totalAmount(double percent) {
    final total = double.parse(widget.totalAmount);
    final charge = total * (percent / 100);
    totalAmmtToBePaid.value = (charge + total).toStringAsFixed(2);
  }

  setSelectType(String type) {
    if (type == "Online".tr) {
      return 'Online';
    } else if (type == "Cash".tr) {
      return 'Cash';
    } else if (type == "WALLET".tr) {
      return 'Wallet';
    }
  }

  paymentTypeIcons(String type) {
    if (type == "Online".tr) {
      return 'assets/images/card_outlined.png';
    } else if (type == "Cash".tr) {
      return 'assets/images/cash.png';
    } else if (type == "WALLET".tr) {
      return 'assets/images/Wallet.png';
    }
  }
}
