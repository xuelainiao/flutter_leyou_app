import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mall_community/common/commStyle.dart';

class MyBadge extends StatelessWidget {
  const MyBadge({
    super.key,
    this.value = 0,
    this.radius = 30,
    this.color = Colors.red,
    this.dot = false,
  });

  final value;
  final double radius;
  final color;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    return value == 0 || value == '0'
        ? const SizedBox()
        : ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            child: dot
                ? ClipOval(
                    child: Container(
                      width: 10,
                      height: 10,
                      color: color,
                    ),
                  )
                : Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    color: errorColor,
                    child: Text(
                      "$value",
                      style: const TextStyle(color: Colors.white),
                      maxLines: 1,
                    ),
                  ),
          );
  }
}
