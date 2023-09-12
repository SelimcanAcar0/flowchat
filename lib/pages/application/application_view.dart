import 'package:flowchat/pages/application/application_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/values/values.dart';
import '../contact/contact_view.dart';
import '../message/message_view.dart';
import '../profile/profile_view.dart';

class ApplicationPage extends GetView<ApplicationController> {
  const ApplicationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageView(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildPageView() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: controller.pageController,
      onPageChanged: controller.handPageChanged,
      children: const [
        MessagePage(),
        ContactPage(),
        ProfilePage(),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Obx(() => BottomNavigationBar(
          items: controller.bottomTabs,
          currentIndex: controller.state.page,
          type: BottomNavigationBarType.fixed,
          onTap: controller.handleNavBarTap,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          unselectedItemColor: AppColors.tabBarElement,
          selectedItemColor: AppColors.thirdElementText,
        ));
  }
}
