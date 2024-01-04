import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
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
                        Text('Hello!',
                            style: TextStyle(
                              fontSize: 44.sp,
                              color: c_333,
                              fontWeight: FontWeight.bold,
                            )),
                        Text(
                          '欢迎使用模板社区平台',
                          style: tx12.copyWith(color: c_333),
                        ),
                        Text(
                          "新用户直接输入默认注册登录",
                          style: tx12.copyWith(color: c_333),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            width: 200.w,
                            child: Image.asset(
                                'lib/assets/image/login/header.png'),
                          ),
                        ),
                        buildForm(keyboardHeight),
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
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  bottom: ScreenUtil().bottomBarHeight + 20.h,
                  child: Column(
                    children: [
                      Container(
                        height: 44.h,
                        padding: const EdgeInsets.only(right: 24, left: 5),
                        decoration: BoxDecoration(
                          color: c_f1f1f1,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(82)),
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
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            '登录代表您已阅读并同意',
                            style: tx12.copyWith(
                              color: c_333,
                            ),
                          ),
                          Text(
                            '《用户协议》',
                            style: tx12.copyWith(
                              color: const Color.fromRGBO(249, 168, 38, 1),
                            ),
                          ),
                          Text(
                            '《隐私政策》',
                            style: tx12.copyWith(
                              color: const Color.fromRGBO(249, 168, 38, 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }

  Widget buildForm(keyboardHeight) {
    return Container(
      width: 1.sw,
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(
        bottom: keyboardHeight,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 0,
            blurRadius: 30,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
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
          BrnTextBlockInputFormItem(
            label: 'password',
            title: '密码',
            hint: '请输入密码',
            minLines: 1,
            maxLines: 1,
            inputType: BrnInputType.pwd,
            onChanged: (value) {
              form['password'] = value;
            },
            // inputType: 'visiblePassword',
          ),
        ],
      ),
    );
  }
}
