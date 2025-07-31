import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonWidget extends StatelessWidget {
//  final String name;
  final VoidCallback ontap;
  final Widget text;
  const ButtonWidget({
    super.key,
    // required this.name,
    required this.ontap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    // SignUpController controller = SignUpController();
    return SizedBox(
        height: GetPlatform.isIOS ? 50 : 45,
        width: double.infinity,
        child: GetPlatform.isIOS
            ? CupertinoButton(
                onPressed: ontap,
                color: const Color(0xFF85080C),
                child: text,
              )
            : ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
                  backgroundColor:
                      WidgetStateProperty.all(const Color(0xFF85080C)),
                ),
                onPressed: ontap,
                child: text));
  }
}
