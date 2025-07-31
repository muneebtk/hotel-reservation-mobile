import 'package:flutter/material.dart';
import '../../../constant/styles/colors.dart';

class BottomNavButton extends StatelessWidget {
  final String price;
  final VoidCallback ontap;
  final Widget buttonName;
  final TextStyle? style;
  const BottomNavButton({
    super.key,
    required this.price,
    required this.buttonName,
    required this.ontap,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(
            price,
            style: style,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )),
          ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(darkRed)),
            onPressed: ontap,
            child: Padding(
                padding: const EdgeInsets.only(bottom: 14, top: 14),
                child: buttonName),
          ),
        ],
      ),
    );
  }
}
