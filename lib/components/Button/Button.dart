import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    this.text = '',
    required this.onPressed,
    this.radius = 0,
    this.color,
    this.icon,
    this.fontSize = 14,
    this.textColor,
    this.borderColor = Colors.white,
  });

  final String text;

  final Function onPressed;

  final double radius;

  final Color? color;

  final Color? textColor;

  final Icon? icon;

  final double fontSize;

  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(
              width: borderColor != Colors.white ? 1 : 0, color: borderColor),
        ),
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        shadowColor: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: icon,
                )
              : const SizedBox(),
          Text(
            text,
            style: TextStyle(fontSize: fontSize.sp, color: textColor),
          ),
        ],
      ),
    );
  }
}
