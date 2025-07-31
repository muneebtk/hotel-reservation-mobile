import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/button/button.dart';
import '../../../../constant/styles/colors.dart';
import '../../../../constant/styles/sizedbox.dart';
import '../../../../getx/count_of_guest.dart';
import 'guest_info_bottom_sheet.dart';

class BottomSheetGustInfo extends StatelessWidget {
  const BottomSheetGustInfo({
    super.key,
    required this.counterControllerFind,
    required this.guest,
    this.checkCHALET,
  });

  final CounterController counterControllerFind;
  final String? checkCHALET;
  final List<String> guest;

  @override
  Widget build(BuildContext context) {
    FocusNode focus = FocusNode();

    final String room = 'room'.tr;
    final String adult = 'adult'.tr;
    final String children = 'children'.tr;
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              decoration: const BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    height20,
                    //? guest info ----------------------
                    isChalet()
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: 2,
                              itemBuilder: (context, index) => Obx(
                                () => GuestInfo(
                                  counter: counterControllerFind
                                      .counters[index + 1]
                                      .toString(),
                                  iconDecrement: () {
                                    counterControllerFind.decrement(
                                        index + 1, 2 == index + 1);
                                  },
                                  iconIncrement: () {
                                    counterControllerFind.increment(index + 1);
                                  },
                                  index: index,
                                  text: guest[index],
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: 3,
                              itemBuilder: (context, index) => Obx(
                                () => GuestInfo(
                                  counter: counterControllerFind.counters[index]
                                      .toString(),
                                  iconDecrement: () {
                                    counterControllerFind.decrement(
                                        index, 3 == index + 1);
                                  },
                                  iconIncrement: () {
                                    counterControllerFind.increment(index);
                                  },
                                  index: index,
                                  text: guest[index],
                                ),
                              ),
                            ),
                          ),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ButtonWidget(
                        text: Text(
                          "apply".tr,
                          style: textColorwhite,
                        ),
                        //name: "Apply",
                        ontap: () {
                          Get.back();
                          focus.unfocus();
                        },
                      ),
                    )

                    //?-------------
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xFFEDF0F9),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              const Icon(Icons.people),
              const SizedBox(width: 15),
              Obx(
                () => checkCHALET == 'CHALET'
                    ? Text(
                        "${counterControllerFind.counters[1]} $adult ${counterControllerFind.counters[2] >= 0 ? ', ${counterControllerFind.counters[2]} $children' : ''}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      )
                    : Text(
                        "${counterControllerFind.counters[0]} $room, ${counterControllerFind.counters[1]} $adult ${counterControllerFind.counters[2] >= 0 ? ', ${counterControllerFind.counters[2]} $children' : ''}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  isChalet() {
    return checkCHALET == 'CHALET';
  }
}
