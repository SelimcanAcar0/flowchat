import 'package:flowchat/common/routes/routes.dart';
import 'package:flowchat/common/store/user.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class RouteAuthMiddleware extends GetMiddleware {
  @override
  RouteAuthMiddleware({required int priority}) : super(priority: priority);

  @override
  RouteSettings? redirect(String? route) {
    if (UserStore.to.isLogin || route == AppRoutes.SIGN_IN || route == AppRoutes.INITIAL) {
      return null;
    } else {
      Future.delayed(const Duration(seconds: 1), () => Get.snackbar('a', 'a'));
      return const RouteSettings(name: AppRoutes.SIGN_IN);
    }
  }
}
