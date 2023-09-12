import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/store/config.dart';
import 'setting_state.dart';

class SettingController extends GetxController {
  final state = SettingState();
  SettingController();

  bool localisTR = ConfigStore.to.locale.value == const Locale('tr') ||
      ConfigStore.to.locale.value == const Locale('tr', 'TR');
}
