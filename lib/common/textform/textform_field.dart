import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:flutter/material.dart';

final FocusNode focus = FocusNode();

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final IconData? icon;
  final TextInputType keyboardType;
  final TextStyle? hintStyle;
  final String? Function(String?)? validator;
  final int? maxLength;
  final FocusNode? focusNode;
  final IconData? visibilityIcon;
  final bool? obseCure;
  final VoidCallback? iconButtonOntap;
  final Color? color;
  final Widget? prefix;
  final Widget? suffix;
  final bool? autofocus;
  final bool? readonly;
  final VoidCallback? onTap;
  final Widget? label;
  final ValueChanged<String>? onChanged;
  final TextCapitalization textCapitalization;

  const TextFormFieldWidget(
      {super.key,
      this.controller,
      this.hintText,
      this.icon,
      this.keyboardType = TextInputType.text,
      this.hintStyle,
      this.validator,
      this.maxLength,
      this.focusNode,
      this.visibilityIcon,
      this.obseCure,
      this.iconButtonOntap,
      this.color,
      this.prefix,
      this.suffix,
      this.autofocus,
      this.readonly,
      this.onTap,
      this.label,
      this.onChanged,
      this.textCapitalization = TextCapitalization.none});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readonly ?? false,
      autofocus: autofocus ?? false,
      focusNode: focusNode,
      controller: controller,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        label: label,
        suffix: suffix,
        prefix: prefix,
        errorStyle: TextStyle(color: color),
        suffixIcon: IconButton(
          icon: Icon(
            visibilityIcon,
            color: kBlack,
          ),
          onPressed: iconButtonOntap,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10),
        hintText: hintText,
        hintStyle: hintStyle,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: icon != null ? Icon(icon) : null,
      ),
      keyboardType: keyboardType,
      obscureText: obseCure ?? false,
      validator: validator,
      maxLength: maxLength,
    );
  }
}
