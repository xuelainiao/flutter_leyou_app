import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/app_config.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/utils/storage.dart';

/// 隐私协议政策
class PrivacyStatementPage extends StatelessWidget {
  const PrivacyStatementPage({super.key});

// 若您不同意盘世界<a href='https://psjdev.t1.junwangfei.cn/h5/#/user/pages/user/privacy?type=user_agreement&title=%E7%94%A8%E6%88%B7%E5%8D%8F%E8%AE%AE&showNavbar=false'>《用户协议》</a>及<a href='https://psjdev.t1.junwangfei.cn/h5/#/user/pages/user/privacy?type=privacy&title=%E9%9A%90%E7%A7%81%E6%94%BF%E7%AD%96&showNavbar=false'>《隐私政策》</a>，很遗憾我们将无法为您提供服务。
  hasAgree(bool agree) {
    if (!agree) {
      // Get.dialog(
      //   ConfirmationDialog(
      //     title: '确认提示',
      //     confirmText: '同意并继续',
      //     cancelText: '退出应用',
      //     content: Text.rich(
      //       style: tx14.copyWith(color: c999),
      //       TextSpan(
      //         text: "若您不同意盘世界",
      //         children: [
      //           WidgetSpan(
      //             child: InkWell(
      //               onTap: () {
      //                 toUinPage(
      //                     "/user/pages/user/privacy?type=user_agreement&title=用户协议&showNavbar=false");
      //               },
      //               child: const Text(
      //                 '《用户协议》',
      //                 style: TextStyle(color: Color.fromRGBO(252, 107, 54, 1)),
      //               ),
      //             ),
      //           ),
      //           const TextSpan(text: '及'),
      //           WidgetSpan(
      //             child: GestureDetector(
      //               onTap: () {
      //                 toUinPage(
      //                     "/user/pages/user/privacy?type=privacy&title=隐私政策&showNavbar=false");
      //               },
      //               child: const Text(
      //                 '《隐私政策》',
      //                 style: TextStyle(color: Color.fromRGBO(252, 107, 54, 1)),
      //               ),
      //             ),
      //           ),
      //           const TextSpan(text: "很遗憾我们将无法为您提供服务。")
      //         ],
      //       ),
      //     ),
      //     isCancel: true,
      //     onConfirm: (res) {
      //       if (!res) {
      //         SystemNavigator.pop();
      //       }
      //       toHome();
      //     },
      //   ),
      // );
      return;
    }
    toHome();
  }

  toHome() {
    AppConfig.privacyStatementHasAgree = true;
    Storage().write('privacyStatementHasAgree', true);
    // AMapFlutterLocation.updatePrivacyShow(true, true);
    // AMapFlutterLocation.updatePrivacyAgree(true);
    Get.offNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      body: Align(
        child: Container(
          constraints: BoxConstraints(
            minHeight: 200.h,
            maxHeight: 290.h,
            maxWidth: 300.w,
          ),
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                height: 56.h,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  '服务协议和隐私政策',
                  style: tx16.copyWith(
                    fontWeight: FontWeight.bold,
                    color: c333,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  child: Text.rich(
                    TextSpan(
                      text:
                          "请你务必审慎阅读、充分理解“服务协议”和“隐私政策”各条款，包括但不限于：为了更好的向你提供服务，我们需要收集你的设备标识、操作日志等信息用于分析、优化应用性能。\n",
                      style: tx14.copyWith(color: c999),
                      children: [
                        const TextSpan(
                            text: '\n', style: TextStyle(height: 0.5)),
                        TextSpan(
                          text: "你可阅读",
                          children: [
                            WidgetSpan(
                              child: InkWell(
                                onTap: () {
                                  // toUinPage(
                                  //     "/user/pages/user/privacy?type=user_agreement&title=用户协议&showNavbar=false");
                                },
                                child: const Text(
                                  '《用户协议》',
                                  style: TextStyle(
                                      color: Color.fromRGBO(252, 107, 54, 1)),
                                ),
                              ),
                            ),
                            const TextSpan(text: '和'),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  // toUinPage(
                                  //     "/user/pages/user/privacy?type=privacy&title=隐私政策&showNavbar=false");
                                },
                                child: const Text(
                                  '《隐私政策》',
                                  style: TextStyle(
                                      color: Color.fromRGBO(252, 107, 54, 1)),
                                ),
                              ),
                            ),
                            const TextSpan(
                                text: '了解详细信息。如果你同意，请点击下面按钮开始接受我们的服务。'),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        hasAgree(false);
                      },
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        child: Text(
                          '不同意',
                          style: TextStyle(fontSize: 15, color: c666),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        hasAgree(true);
                      },
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        child: const Text(
                          '同意并继续',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(252, 107, 54, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
