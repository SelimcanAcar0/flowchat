import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flowchat/common/services/storage.dart';
import 'package:flowchat/common/store/store.dart';
import 'package:flowchat/common/style/theme.dart';
import 'package:flowchat/common/values/texts.dart';
import 'package:flowchat/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'common/routes/pages.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.black87),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync<StorageService>(() => StorageService().init());
  await EasyLocalization.ensureInitialized();
  Get.put<ConfigStore>(
    ConfigStore(),
  );
  Get.put<UserStore>(UserStore());

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        builder: (BuildContext context, Widget? child) => GetMaterialApp(
              locale: ConfigStore.to.locale.value,
              translations: LocaleString(),
              theme: AppTheme.light,
              themeMode: ConfigStore.to.isDarkTheme.value
                  ? ThemeMode.dark
                  : ThemeMode.light,
              defaultTransition: Transition.fade,
              darkTheme: AppTheme.dark,
              debugShowCheckedModeBanner: false,
              initialRoute: ConfigStore.to.isFirstOpen.value
                  ? AppPages.INITIAL
                  : AppPages.APPlication,
              getPages: AppPages.routes,
            ));
  }
}
