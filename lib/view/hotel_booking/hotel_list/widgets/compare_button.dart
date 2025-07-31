import 'package:flutter/material.dart';
import '../../../../constant/styles/colors.dart';

class CompareButton extends StatelessWidget {
  final VoidCallback? ontap;
  final Widget text;
  final Widget icon;
  const CompareButton({
    super.key,
    required this.ontap,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: const ButtonStyle(
          side: WidgetStatePropertyAll(BorderSide(color: kBlack)),
          backgroundColor: WidgetStatePropertyAll(kWhite),
        ),
        onPressed: ontap,
        icon: icon,
        label: text);
  }
}
