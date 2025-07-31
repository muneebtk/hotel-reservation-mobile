import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/styles/sizedbox.dart';

class Appbar extends StatelessWidget {
  final IconData? icon;
  final String? subtitle;
  final String? trailingTitle;
  final String title;
  final String? adults;
  final double? trailingFontsize;
  final double? titleFontSize;
  final VoidCallback? onTap;
  final IconData? peopleIcon;
  final VoidCallback? titleOnTap;
  final Widget? onTapCompare;

  const Appbar(
      {super.key,
      required this.title,
      this.onTapCompare,
      this.subtitle,
      this.trailingTitle,
      this.icon,
      this.adults,
      this.trailingFontsize,
      this.titleFontSize,
      this.onTap,
      this.titleOnTap,
      this.peopleIcon});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        Padding(padding: const EdgeInsets.all(8.0), child: onTapCompare)
      ],
      title: GestureDetector(
        onTap: titleOnTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height15,
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: titleFontSize),
            ),
            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  size: 11,
                ),
                width5,
                Text(
                  subtitle!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10),
                ),
                width10,
                // InkWell(
                //   onTap: onTapCompare,
                //   child: Icon(
                //     peopleIcon,
                //     color: kBlack,
                //     size: 11,
                //   ),
                // ),
                Expanded(
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    adults.toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
