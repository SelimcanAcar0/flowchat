import 'package:flowchat/common/store/config.dart';
import 'package:flowchat/pages/profile/settings/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../../common/values/colors.dart';
import '../../../common/widgets/app.dart';

class SettingPage extends GetView<SettingController> {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SafeArea(
        child: Scaffold(
            appBar: _buildAppBar(), body: _settingPageView(controller))));
  }
}

AppBar _buildAppBar() {
  return customAppBar(
      title: Text(
    'settings'.tr,
    style: TextStyle(
        color: AppColors.primaryBackground,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600),
  ));
}

SettingsList _settingPageView(SettingController controller) {
  var isDarkTheme = ConfigStore.to.isDarkTheme.value;
  return SettingsList(
    applicationType: ApplicationType.cupertino,
    sections: [
      SettingsSection(
          title: Text('general'.tr),
          tiles: [_settingLanguage(controller), _settingTheme(isDarkTheme)]),
    ],
  );
}

SettingsTile _settingTheme(bool isDarkTheme) {
  return SettingsTile.switchTile(
    initialValue: isDarkTheme,
    title: Text('darkMode'.tr),
    leading: const Icon(Icons.dark_mode_outlined),
    onToggle: (bool value) {
      ConfigStore.to.onThemeUpdate(value);
    },
  );
}

SettingsTile _settingLanguage(SettingController controller) {
  return SettingsTile.navigation(
    title: Text('language'.tr),
    leading: const Icon(Icons.language),
    value: controller.localisTR
        ? Text(ConfigStore.to.localeList[0]['name'])
        : Text(ConfigStore.to.localeList[1]['name']),
    onPressed: (context) {
      _chooseLanguageDialog(context);
    },
  );
}

Future<dynamic> _chooseLanguageDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          title: Text('chooseLang'.tr),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Text(ConfigStore.to.localeList[index]['name']),
                      onTap: () {
                        ConfigStore.to.onLocaleUpdate(
                            ConfigStore.to.localeList[index]['locale']);
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: Colors.blue,
                  );
                },
                itemCount: ConfigStore.to.localeList.length),
          ),
        );
      });
}
