import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/styles/colors.dart';
import '../../../../constant/styles/sizedbox.dart';

class GenderSelectionWidget extends StatelessWidget {
  const GenderSelectionWidget({
    super.key,
    required this.selectedOption,
    required this.option,
  });

  final RxString selectedOption;
  final String option;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectedOption.value = option;
      },
      child: Obx(() => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: darkRed),
              color:
                  selectedOption.value == option ? darkRed : Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (selectedOption.value == option)
                    const Icon(
                      Icons.chalet_outlined,
                      color: kWhite,
                    ),
                  width5,
                  Text(
                    option,
                    style: TextStyle(
                        color:
                            selectedOption.value == option ? kWhite : darkRed),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
