import 'package:ecommerce_user/core/constants/dimensions.dart';
import 'package:ecommerce_user/core/extensions/style.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color? color;
  final double? width;
  final double borderRadius;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = 8,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Theme.of(context).primaryColor,
        padding: padding ?? const EdgeInsets.symmetric(vertical: Dimensions.paddingSmall, horizontal: Dimensions.paddingSmall),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(text, style: const TextStyle().regular.copyWith(color: textColor ?? Theme.of(context).cardColor)),
    );
  }
}

