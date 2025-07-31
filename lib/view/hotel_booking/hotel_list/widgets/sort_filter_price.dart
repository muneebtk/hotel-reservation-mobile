import 'package:flutter/material.dart';

class SortFilterPriceButton extends StatelessWidget {
  final String text;
  final String icon;
  final IconData arrowdown;

  const SortFilterPriceButton({
    super.key,
    required this.text,
    required this.icon,
    required this.arrowdown,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          icon,
          height: 20,
          width: 20,
        ),
        const SizedBox(width: 8),
        Text(text),
        Icon(arrowdown),
      ],
    );
  }
}
