import 'package:flutter/material.dart';
import 'package:mall_community/common/commStyle.dart';
import 'package:mall_community/components/Badge/Badge.dart';
import 'package:mall_community/components/NewWorkImageWidget/NewWorkImageWidget.dart';

class MyAvatar extends StatelessWidget {
  const MyAvatar({
    super.key,
    required this.src,
    this.color,
    this.radius = 4,
    this.size = 40,
    this.nums = '',
  });

  final String src;
  final double radius;
  final color;
  final double size;
  final String nums;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.topRight,
        clipBehavior: Clip.none,
        children: [
          NetWorkImg(
            src,
            raduis: radius,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
          nums.isEmpty == true
              ? const SizedBox()
              : Positioned(
                  top: -2,
                  right: -2,
                  child: MyBadge(
                    dot: true,
                    value: 10,
                    color: successColor,
                  ),
                )
        ],
      ),
    );
  }
}
