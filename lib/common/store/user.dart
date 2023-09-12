import 'dart:convert';
import 'package:flowchat/common/entities/entities.dart';
import 'package:flowchat/common/services/storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';

import '../../pages/sign_in/signin_index.dart';
import '../routes/routes.dart';
import '../values/storage.dart';

class UserStore extends GetxController {
  static UserStore get to => Get.find();

  final _isLogin = false.obs;

  String token = '';

  final _profile = UserLoginResponseEntity().obs;

  bool get isLogin => _isLogin.value;
  UserLoginResponseEntity get profile => _profile.value;
  bool get hasToken => token.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    token = StorageService.to.getString(STORAGE_USER_TOKEN_KEY);
    var profileOffline = StorageService.to.getString(STORAGE_USER_PROFILE_KEY);
    if (profileOffline.isNotEmpty) {
      _isLogin.value = true;
      _profile(UserLoginResponseEntity.fromJson(jsonDecode(profileOffline)));
    }
  }

  Future<void> setToken(String value) async {
    await StorageService.to.setString(STORAGE_USER_TOKEN_KEY, value);
    token = value;
  }

  Future<String> getProfile() async {
    if (token.isEmpty) return '';
    //var result = await UserAPI.profile();
    //_profile(result);
    _isLogin.value = true;
    return StorageService.to.getString(STORAGE_USER_PROFILE_KEY);
  }

  Future<void> saveProfile(UserLoginResponseEntity profile) async {
    _isLogin.value = true;
    StorageService.to.setString(STORAGE_USER_PROFILE_KEY, jsonEncode(profile));
    StorageService.to.setString(STORAGE_USER_TYPE, profile.type!);
    setToken(profile.accessToken!);
    _profile(profile);
  }

  Future<String> getUserType() async {
    return StorageService.to.getString(STORAGE_USER_TYPE);
  }

  Future<void> onLogOut() async {
    var type = utf8.encode(StorageService.to.getString(STORAGE_USER_TYPE));
    var googleType = utf8.encode('google');
    if (type.toString() == googleType.toString()) {
      await googleSignIn.signOut();
    } else {
      await FacebookAuth.instance.logOut();
    }
    Get.offAndToNamed(AppRoutes.SIGN_IN);
  }
}
