import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mall_community/common/commStyle.dart';

class AppTheme {
  /// 通用大小 标题栏icon
  static IconThemeData appBarIconThem = IconThemeData(
    color: Colors.white,
    size: 24.sp,
  );

  /// 白色
  static final lightTheme = ThemeData(
    primarySwatch: Colors.pink,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  /// 黑色
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.pink,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  /// 橙色
  static final primaryTheme = ThemeData(
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: primaryColor,
    appBarTheme: AppBarTheme(
      color: primaryNavColor,
      titleTextStyle: TextStyle(fontSize: 16.sp),
      shadowColor: Colors.transparent,
      iconTheme: appBarIconThem,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: primaryTextC),
    ),
    bottomAppBarTheme: const BottomAppBarTheme(),
  );
}
