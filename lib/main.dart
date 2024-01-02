import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mall_community/app.dart';
import 'package:mall_community/common/appConfig.dart';
import 'package:mall_community/modules/userModule.dart';
import 'package:mall_community/utils/storage.dart';

void main() async {
  await init();
  runApp(const MyApp());
}

init() async {
  await GetStorage.init();

  // 隐私政策
  AppConfig.privacyStatementHasAgree =
      Storage().read('privacyStatementHasAgree') ?? false;
  UserInfo.token = Storage().read('token') ?? '';
}
