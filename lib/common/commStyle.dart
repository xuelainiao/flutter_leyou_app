import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 常用颜色
Color c_ccc = const Color.fromRGBO(204, 204, 204, 1);
Color c_666 = const Color.fromRGBO(102, 102, 102, 1);
Color c_ee4c3d = const Color.fromRGBO(238, 76, 61, 1);
Color c_333 = const Color.fromRGBO(51, 51, 51, 1);
Color c_999 = const Color.fromRGBO(153, 153, 153, 1);
Color c_f1f1f1 = const Color.fromRGBO(241, 241, 241, 1);
Color c_898989 = const Color.fromRGBO(137, 137, 137, 1);
Color c_aaaaaa = const Color.fromRGBO(170, 170, 170, 1);

/// 常用字体大小
TextStyle tx10 = TextStyle(fontSize: 10.sp, color: primaryTextC);
TextStyle tx12 = TextStyle(fontSize: 12.sp, color: primaryTextC);
TextStyle tx14 = TextStyle(fontSize: 14.sp, color: primaryTextC);
TextStyle tx16 = TextStyle(fontSize: 16.sp, color: primaryTextC);
TextStyle tx18 = TextStyle(fontSize: 18.sp, color: primaryTextC);
TextStyle tx20 = TextStyle(fontSize: 20.sp, color: primaryTextC);
TextStyle tx22 = TextStyle(fontSize: 22.sp, color: primaryTextC);

/**
 * 系统主题色
 * */
///主题色
Color primaryColor = HexColor("#A593E0");

/// 导航栏颜色
Color primaryNavColor = HexColor("#D1B6E1");

/// 成功
Color successColor = HexColor("#5CAB7D");

/// 错误
Color errorColor = HexColor("#F16B6F");

/// 警告
Color warningColor = HexColor("#ffc952");

/// info
Color infoColor = HexColor("#a3a1a1");

/// 背景色
Color backgroundColor = HexColor("#f3f4f6");

/// 边框颜色
Color borderColor = HexColor("#e4e7ed");

/**
 * 常用文字颜色
 * */
/// 主要文字颜色
Color primaryTextC = HexColor("#303133");

/// 常规文字颜色
Color routineTextC = HexColor("#606266");

/// 次要文字颜色
Color secondaryTextC = HexColor("#909399");

/// 占位文字颜色
Color placeholderTextC = HexColor("#e3dede");

///Hex转换函数
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
