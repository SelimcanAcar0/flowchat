// ignore_for_file: constant_identifier_names

import 'package:flowchat/pages/profile/settings/setting_index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../pages/application/application_index.dart';
import '../../pages/contact/contact_index.dart';
import '../../pages/message/chat/chat_index.dart';
import '../../pages/message/photoview/photoview_index.dart';
import '../../pages/profile/profile_index.dart';
import '../../pages/sign_in/signin_index.dart';
import '../../pages/welcome/welcome_index.dart';
import '../middlewares/router_auth.dart';
import 'routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.INITIAL;
  static const SIGN_IN = AppRoutes.SIGN_IN;
  static const APPlication = AppRoutes.Application;
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.INITIAL,
      page: () => const WelcomePage(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: AppRoutes.SIGN_IN,
      page: () => const SignInPage(),
      binding: SignInBinding(),
    ),

    // check if needed to login or not
    GetPage(
      name: AppRoutes.Application,
      page: () => const ApplicationPage(),
      binding: ApplicationBinding(),
      middlewares: [
        RouteAuthMiddleware(priority: 1),
      ],
    ),

    GetPage(
        name: AppRoutes.Contact,
        page: () => const ContactPage(),
        binding: ContactBinding()),

    GetPage(
        name: AppRoutes.settingPage,
        page: () => const SettingPage(),
        binding: SettingBinding()),
    /*
    GetPage(name: AppRoutes.Message, page: () => MessagePage(), binding: MessageBinding()),
    */
    GetPage(
        name: AppRoutes.Me,
        page: () => const ProfilePage(),
        binding: ProfileBinding()),

    GetPage(
      name: AppRoutes.Chat,
      page: () => const ChatPage(),
      binding: ChatBinding(),
    ),

    GetPage(
        name: AppRoutes.Photoimgview,
        page: () => const PhotoImageView(),
        binding: PhotoImageViewBinding()),
  ];
}
