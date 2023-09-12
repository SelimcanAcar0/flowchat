import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/values/values.dart';
import 'application_index.dart';

class ApplicationController extends GetxController {
  final state = ApplicationState();
  ApplicationController();

  late final List<String> tabTitles;
  late final PageController pageController;
  late final List<BottomNavigationBarItem> bottomTabs;

  void handPageChanged(int index) {
    state.page = index;
  }

  void handleNavBarTap(int index) {
    pageController.jumpToPage(index);
  }

  @override
  void onInit() {
    super.onInit();
    bottomTabs = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: const Icon(
            Icons.message,
            color: AppColors.thirdElementText,
          ),
          activeIcon: const Icon(
            Icons.message,
            color: AppColors.secondaryElementText,
          ),
          label: 'chat'.tr,
          backgroundColor: AppColors.primaryBackground),
      BottomNavigationBarItem(
          icon: const Icon(
            Icons.contact_page,
            color: AppColors.thirdElementText,
          ),
          activeIcon: const Icon(
            Icons.contact_page,
            color: AppColors.secondaryElementText,
          ),
          label: 'contact'.tr,
          backgroundColor: AppColors.primaryBackground),
      BottomNavigationBarItem(
          icon: const Icon(
            Icons.person,
            color: AppColors.thirdElementText,
          ),
          activeIcon: const Icon(
            Icons.person,
            color: AppColors.secondaryElementText,
          ),
          label: 'profile'.tr,
          backgroundColor: AppColors.primaryBackground)
    ];
    pageController = PageController(initialPage: state.page);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
