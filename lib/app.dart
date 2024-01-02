import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/theme.dart';
import 'package:mall_community/router/router.dart';

import 'common/appConfig.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyappState();
}

class _MyappState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, child) {
        return GetMaterialApp(
          // initialBinding: ActionInjector(),
          getPages: AppPages.pages,
          title: '商店社区',
          initialRoute: AppConfig.privacyStatementHasAgree
              ? '/home'
              : '/privacyStatement',
          showPerformanceOverlay: false,
          theme: AppTheme.originTheme,
          builder: EasyLoading.init(),
          defaultTransition: Transition.rightToLeft,
          // // 国际化支持 目前只有中文
          // localizationsDelegates: GlobalMaterialLocalizations.delegates,
          // supportedLocales: Platform.isIOS ? ios : an,
          locale: const Locale('zh'),
        );
      },
    );
  }
}

List<Locale> an = [
  const Locale('zh', 'CN'),
  const Locale('en', 'US'),
];
List<Locale> ios = [
  const Locale('en', 'US'),
  const Locale('zh', 'CN'),
];
