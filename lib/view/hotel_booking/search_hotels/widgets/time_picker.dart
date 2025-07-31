import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/styles/sizedbox.dart';

class TimePicker extends StatelessWidget {
  final String time;
  final VoidCallback showTimeOnTap;
  const TimePicker({
    super.key,
    required this.time,
    required this.showTimeOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("time".tr),
        Container(
          color: const Color(0xFFEDF0F9),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                GestureDetector(
                    onTap: showTimeOnTap, child: const Icon(Icons.access_time)),
                width15,
                Text(
                  time,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
