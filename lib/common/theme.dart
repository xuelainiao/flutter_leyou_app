import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  static final originTheme = ThemeData(
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: AppBarTheme(
      color: const Color.fromRGBO(252, 107, 54, 1),
      titleTextStyle: TextStyle(fontSize: 16.sp),
      shadowColor: Colors.transparent,
      iconTheme: appBarIconThem,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color.fromRGBO(252, 107, 54, 1),
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(252, 107, 54, 1),
        foregroundColor: Colors.white,
      ),
    ),
    bottomAppBarTheme: const BottomAppBarTheme(),
  );
}
