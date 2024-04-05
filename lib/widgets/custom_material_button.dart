import 'package:flutter/material.dart';

class CustomMaterialButton extends StatelessWidget {
  final String text;
  final double? height;
  final double? width;
  final VoidCallback onPress;
  final Color? backgroundColor;
  final Color? fontColor;
  final double? radius;

  const CustomMaterialButton({
    super.key,
    required this.text,
    this.height,
    this.width,
    required this.onPress,
    this.backgroundColor,
    this.radius,
    this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: MaterialButton(
        elevation: 8,
        color: backgroundColor,
        height: height,
        onPressed: onPress,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: fontColor ?? Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
