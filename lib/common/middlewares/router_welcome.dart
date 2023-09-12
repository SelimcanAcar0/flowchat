import 'package:flowchat/common/routes/routes.dart';
import 'package:flowchat/common/store/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// first time open
class RouteWelcomeMiddleware extends GetMiddleware {
  RouteWelcomeMiddleware({required int priority}) : super(priority: priority);

  @override
  RouteSettings? redirect(String? route) {
    print('isFirstOpen: ${ConfigStore.to.isFirstOpen.value}');
    if (ConfigStore.to.isFirstOpen.value == false) {
      return null;
    } else if (UserStore.to.isLogin == true) {
      return const RouteSettings(name: AppRoutes.Application);
    } else {
      return const RouteSettings(name: AppRoutes.SIGN_IN);
    }
  }
}
