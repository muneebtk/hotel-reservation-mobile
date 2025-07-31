import 'dart:io';

import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constant/styles/colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actionsANDROID;
  final Widget? trailingIOS;
  final bool? automaticallyImplyLeadingANDROID;

  const MyAppBar(
      {super.key,
      required this.title,
      this.actionsANDROID,
      this.trailingIOS,
      this.automaticallyImplyLeadingANDROID});

  @override
  Size get preferredSize =>
      Size.fromHeight(Platform.isIOS ? 56.0 : kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            automaticallyImplyLeading: automaticallyImplyLeadingANDROID ?? true,
            trailing: trailingIOS,
            middle: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: 'IBMPlexSansArabic'),
            ),
            backgroundColor: CupertinoColors.systemGrey6.withOpacity(0.8),
          )
        : AppBar(
            automaticallyImplyLeading: automaticallyImplyLeadingANDROID ?? true,
            actions: actionsANDROID,
            title: Row(
              children: [
                Text(
                  title,
                  style: textBoldblack,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            centerTitle: true,
          );
  }
}

class CupertinoButtonWidget extends StatelessWidget {
  const CupertinoButtonWidget({
    super.key,
    required this.ontap,
    required this.text,
  });

  final VoidCallback ontap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5),
      borderRadius: BorderRadius.circular(30),
      color: kGrey[50],
      onPressed: ontap,
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, color: kBlack),
      ),
    );
  }
}
