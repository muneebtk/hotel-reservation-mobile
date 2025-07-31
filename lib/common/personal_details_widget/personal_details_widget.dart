import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constant/styles/colors.dart';
import '../../getx/personal_detail_controller.dart';

class DropdownWidget extends StatelessWidget {
  final PersonalDetailController dropdownController =
      Get.put(PersonalDetailController());

  DropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 5,
      child: Obx(() {
        return DropdownButtonFormField<String>(
          dropdownColor: kWhite,
          value: dropdownController.selectedValue.value,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: 'Title',
            labelStyle: const TextStyle(fontSize: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          items: <String>['Mr', 'Mrs', 'Ms']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              dropdownController.setSelectedValue(newValue);
            }
          },
        );
      }),
    );
  }
}
