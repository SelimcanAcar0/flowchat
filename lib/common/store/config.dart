import 'package:flowchat/common/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';

import '../values/storage.dart';

class ConfigStore extends GetxController {
  static ConfigStore get to => Get.find();

  RxBool isFirstOpen = true.obs;
  PackageInfo? _platform;
  String get version => _platform?.version ?? '-';
  Rx locale = const Locale('en', 'US').obs;
  final RxList localeList = [
    {'name': 'Türkçe', 'locale': const Locale('tr', 'TR')},
    {'name': 'English', 'locale': const Locale('en', 'US')},
  ].obs;
  RxBool isDarkTheme = false.obs;

  @override
  void onInit() async {
    super.onInit();

    isFirstOpen = StorageService.to.getBool(STORAGE_DEVICE_FIRST_OPEN_KEY).obs;
    locale = Locale(StorageService.to.getString(STORAGE_LANGUAGE_CODE)).obs;
    isDarkTheme = StorageService.to.getBool(STORAGE_THEME_CODE).obs;
    print('is first open: $isFirstOpen');
    print(locale);
    print(isDarkTheme.value);
  }

  // remember first time open APP
  Future<bool> saveAlreadyOpen() {
    return StorageService.to.setBool(STORAGE_DEVICE_FIRST_OPEN_KEY, false);
  }

  Future<void> getPlatform() async {
    _platform = await PackageInfo.fromPlatform();
  }

  Future<ConfigStore?> onInitLocale() async {
    var langCode = locale;
    if (langCode.value == '') return this;
    var index = localeList.indexWhere((element) {
      return element.languageCode == langCode;
    }).obs;
    if (index < 0) return this;
    locale = localeList[index.value];
    print(langCode);
    return null;
  }

  void onLocaleUpdate(Locale value) {
    locale.value = value;
    Get.back();
    Get.updateLocale(value);
    StorageService.to.setString(STORAGE_LANGUAGE_CODE, value.languageCode);
    print(value);
  }

  void onThemeUpdate(bool value) async {
    isDarkTheme.value = value;
    Get.changeThemeMode(isDarkTheme.value ? ThemeMode.dark : ThemeMode.light);
    await StorageService.to.setBool(STORAGE_THEME_CODE, isDarkTheme.value);
    print(isDarkTheme.value);
  }
}
