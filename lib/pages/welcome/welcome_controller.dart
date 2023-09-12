import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flowchat/common/store/store.dart';
import 'package:flowchat/pages/welcome/welcome_index.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../common/routes/names.dart';
import '../../common/services/network.dart';
import '../../common/store/config.dart';

class WelcomeController extends GetxController {
  final state = WelcomeState();
  RxBool connection = false.obs;
  final MyConnectivity _connectivity = MyConnectivity.instance;
  @override
  void onInit() {
    super.onInit();
    _connectivity.initialise();
    _connectivity.myStream.listen((event) {
      switch (event) {
        case ConnectivityResult.wifi:
          connection.value = true;
        case ConnectivityResult.mobile:
          connection.value = true;
        case ConnectivityResult.none:
          connection.value = false;
      }
      print(event);
      print('Connection : $connection');
    });
  }

  FocusNode focusNode = FocusNode();
  WelcomeController();
  changePage(int index) async {
    state.index.value = index;
  }

  handleSignIn() async {
    await ConfigStore.to.saveAlreadyOpen();
    Get.offAndToNamed(AppRoutes.SIGN_IN);
  }
}
