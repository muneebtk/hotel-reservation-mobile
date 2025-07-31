import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/styles/sizedbox.dart';

class CheckInCheckout extends StatelessWidget {
  final String text;

  const CheckInCheckout({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: const Color(0xFFEDF0F9),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              const Icon(Icons.check),
              width15,
              Text(
                "mr".tr,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              )
            ],
          ),
        ),
      ),
    );
  }
}
