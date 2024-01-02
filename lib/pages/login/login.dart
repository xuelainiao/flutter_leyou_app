import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/api/login.dart';
import 'package:mall_community/common/commStyle.dart';
import 'package:mall_community/utils/storage.dart';
import 'package:mall_community/utils/toast/toast.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  Map form = {'username': '', 'password': ''};

  login() async {
    if (form['username'].isEmpty) {
      ToastUtils.showToast('请输入正确的账号密码');
      return;
    }
    ToastUtils.showLoad(message: '登录中...');
    var reuslt = await reqLogin(form);
    Storage().write('user_info', reuslt.data['user']);
    Storage().write('token', reuslt.data['token']);
    Get.back();
    ToastUtils.hideLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          height: 1.sh,
          width: 1.sw,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '账号密码登录',
                          style: tx20.copyWith(color: c_333),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30.h),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: c_f1f1f1),
                            ),
                          ),
                          child: BrnTextBlockInputFormItem(
                            label: 'username',
                            hint: '请输入登录账号',
                            title: '登录账号',
                            minLines: 1,
                            maxLines: 1,
                            onChanged: (value) {
                              form['username'] = value;
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: c_f1f1f1),
                            ),
                          ),
                          child: BrnTextBlockInputFormItem(
                            label: 'password',
                            title: '密码',
                            hint: '请输入密码',
                            minLines: 1,
                            maxLines: 1,
                            onChanged: (value) {
                              form['password'] = value;
                            },
                            // inputType: 'visiblePassword',
                          ),
                        ),
                        GestureDetector(
                          onTap: login,
                          child: Container(
                            width: 1.sw,
                            height: 44.h,
                            margin: const EdgeInsets.only(top: 44),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(44)),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromRGBO(255, 221, 25, 1),
                                  Color.fromRGBO(252, 203, 34, 1),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(253, 206, 34, 0.5),
                                  spreadRadius: 0,
                                  blurRadius: 20,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              "立即登录",
                              style: tx16.copyWith(
                                color: c_333,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {}, child: const Text('新用户账号注册')),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: ScreenUtil().bottomBarHeight + 20.h,
                child: Container(
                  height: 44.h,
                  padding: const EdgeInsets.only(right: 24, left: 5),
                  decoration: BoxDecoration(
                    color: c_f1f1f1,
                    borderRadius: const BorderRadius.all(Radius.circular(82)),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "lib/assets/image/login/wxicon.png",
                        width: 38.r,
                        height: 38.r,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '微信账号登录',
                        style: tx14.copyWith(color: c_999),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
