// 提供五套可选主题色
import 'dart:convert';

import 'package:fdemo1213/model/profile.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class Global {
  static SharedPreferences preferences;
  static PackageInfo packageInfo;

  static Profile profile = Profile();
  static List<MaterialColor> get themes => _themes;
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");
  static Future init() async {
    // 初始化数据缓存
    preferences = await SharedPreferences.getInstance();
    packageInfo = await PackageInfo.fromPlatform();
    var _profile = preferences.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }
  }

  // 持久化Profile信息
  static saveProfile() =>
      preferences.setString("profile", jsonEncode(profile.toJson()));
}
