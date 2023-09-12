import 'dart:convert';
import 'package:flowchat/pages/profile/profile_index.dart';
import 'package:flowchat/pages/sign_in/signin_controller.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';

import '../../common/entities/entities.dart';
import '../../common/routes/routes.dart';
import '../../common/services/storage.dart';
import '../../common/store/user.dart';
import '../../common/values/storage.dart';

class ProfileController extends GetxController {
  final ProfileState state = ProfileState();
  /* final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly'
    ]
  );*/

  asyncLoadAllData() async {
    String profile = await UserStore.to.getProfile();
    if (profile.isNotEmpty) {
      UserLoginResponseEntity userdata = UserLoginResponseEntity.fromJson(jsonDecode(profile));
      state.headDetail.value = userdata;
    }
  }

  Future<void> onLogOut() async {
    var type = utf8.encode(StorageService.to.getString(STORAGE_USER_TYPE));
    var googleType = utf8.encode('google');
    if (type.toString() == googleType.toString()) {
      await SignInController.to.signOut();
    } else {
      await FacebookAuth.instance.logOut();
    }
    await UserStore.to.onLogOut();
    Get.offAndToNamed(AppRoutes.SIGN_IN);
  }

  void goSettings() {
    Get.toNamed(
      AppRoutes.settingPage,
    );
  }

  @override
  void onInit() {
    super.onInit();
    asyncLoadAllData();
    List myList = [
      {'name': 'account'.tr, 'icon': 'assets/icons/1.png', 'route': '/account'},
      {'name': 'settings'.tr, 'icon': 'assets/icons/settings.png', 'route': '/settings'},
      {'name': 'chat'.tr, 'icon': 'assets/icons/2.png', 'route': '/chat'},
      {'name': 'notification'.tr, 'icon': 'assets/icons/3.png', 'route': '/notification'},
      {'name': 'privacy'.tr, 'icon': 'assets/icons/4.png', 'route': '/privacy'},
      {'name': 'help'.tr, 'icon': 'assets/icons/5.png', 'route': '/help'},
      {'name': 'about'.tr, 'icon': 'assets/icons/6.png', 'route': '/about'},
      {'name': 'logout'.tr, 'icon': 'assets/icons/7.png', 'route': '/logout'},
    ];

    for (int i = 0; i < myList.length; i++) {
      MeListItem result = MeListItem();
      result.icon = myList[i]['icon'];
      result.name = myList[i]['name'];
      result.route = myList[i]['route'];
      state.meListItem.add(result);
    }
  }
}
