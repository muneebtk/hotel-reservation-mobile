import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/styles/colors.dart';

class RoomIncludedOptions extends StatelessWidget {
  const RoomIncludedOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "breakfast_included".tr,
          style: const TextStyle(color: darkRed, fontSize: 12),
        ),
      ),
    );
  }
}
