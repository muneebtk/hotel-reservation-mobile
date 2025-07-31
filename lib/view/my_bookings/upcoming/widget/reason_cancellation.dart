import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../../../../constant/styles/colors.dart';
import '../cancellation_page.dart';

class CancellationReason extends StatelessWidget {
  const CancellationReason({
    super.key,
    required this.controller,
  });

  final CancellationController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        margin: const EdgeInsets.all(15),
        color: kWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                'Reason for cancellation'.tr,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              minTileHeight: 10,
              title: Text('Change of plans'.tr),
              trailing: Radio<String>(
                fillColor: const WidgetStatePropertyAll(darkRed),
                value: 'Change of plans'.tr,
                groupValue: controller.selectedReason.value,
                onChanged: (value) {
                  if (value != null) {
                    controller.updateReason(value);
                  }
                },
              ),
            ),
            ListTile(
              minTileHeight: 10,
              title: Text('Prefer a different location'.tr),
              trailing: Radio<String>(
                fillColor: const WidgetStatePropertyAll(darkRed),
                value: 'Prefer a different location'.tr,
                groupValue: controller.selectedReason.value,
                onChanged: (value) {
                  if (value != null) {
                    controller.updateReason(value);
                  }
                },
              ),
            ),
            ListTile(
              minTileHeight: 10,
              title: Text('Unsatisfactory reviews or feedback'.tr),
              trailing: Radio<String>(
                fillColor: const WidgetStatePropertyAll(darkRed),
                value: 'Unsatisfactory reviews or feedback'.tr,
                groupValue: controller.selectedReason.value,
                onChanged: (value) {
                  if (value != null) {
                    controller.updateReason(value);
                  }
                },
              ),
            ),
            ListTile(
              minTileHeight: 10,
              title: Text('Hotel amenities not suitable'.tr),
              trailing: Radio<String>(
                fillColor: const WidgetStatePropertyAll(darkRed),
                value: 'Hotel amenities not suitable'.tr,
                groupValue: controller.selectedReason.value,
                onChanged: (value) {
                  if (value != null) {
                    controller.updateReason(value);
                  }
                },
              ),
            ),
            ListTile(
              minTileHeight: 10,
              title: Text('Found a better rate'.tr),
              trailing: Radio<String>(
                fillColor: const WidgetStatePropertyAll(darkRed),
                value: 'Found a better rate'.tr,
                groupValue: controller.selectedReason.value,
                onChanged: (value) {
                  if (value != null) {
                    controller.updateReason(value);
                  }
                },
              ),
            ),
            ListTile(
              minTileHeight: 10,
              title: Text('Other'.tr),
              trailing: Radio<String>(
                fillColor: const WidgetStatePropertyAll(darkRed),
                value: 'Other'.tr,
                groupValue: controller.selectedReason.value,
                onChanged: (value) {
                  if (value != null) {
                    controller.updateReason(value);
                  }
                },
              ),
            ),
            if (controller.selectedReason.value == 'Other'.tr)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Enter your reason'.tr,
                  ),
                  onChanged: (value) {},
                ),
              ),
          ],
        ),
      ),
    );
  }
}
