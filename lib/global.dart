import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'common/services/storage.dart';
import 'common/store/config.dart';
import 'common/store/user.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
class Global{
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Get.putAsync<StorageService>(() => StorageService().init());
    Get.put<ConfigStore>(ConfigStore());
    Get.put<UserStore>(UserStore());

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}