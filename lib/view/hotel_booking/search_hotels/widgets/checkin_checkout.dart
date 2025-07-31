import 'package:flutter/material.dart';
import '../../../../constant/styles/sizedbox.dart';
import '../../../../constant/styles/textstyle.dart';

class CheckInCheckout extends StatelessWidget {
  final String text;
  final String date;
  final VoidCallback onTap;
  const CheckInCheckout({
    super.key,
    required this.text,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: textBoldblack,
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
                color: const Color(0xFFEDF0F9),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: onTap, child: const Icon(Icons.calendar_month)),
                  width15,
                  Expanded(
                    child: Text(
                      date,
                      overflow: TextOverflow.visible,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
