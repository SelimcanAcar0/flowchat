import 'package:flowchat/pages/profile/profile_index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/entities/entities.dart';
import '../../common/store/config.dart';
import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
import 'widgets/head_item.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);
  AppBar _buildAppbar() {
    return customAppBar(
        title: Text(
      'profile'.tr,
      style: TextStyle(color: AppColors.primaryBackground, fontSize: 18.sp, fontWeight: FontWeight.w600),
    ));
  }

  Widget meItem(MeListItem item) {
    return Container(
      height: 56.w,
      color: ConfigStore.to.isDarkTheme.value ? Colors.black : Colors.white,
      margin: EdgeInsets.only(bottom: 1.w),
      padding: EdgeInsets.only(top: 0.w, left: 15.w, right: 15.w),
      child: InkWell(
        onTap: () {
          switch (item.route) {
            case '/logout':
              controller.onLogOut();
            case '/settings':
              controller.goSettings();
            default:
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 56.w,
                  child: Image(
                    image: AssetImage(item.icon ?? ''),
                    width: 40.w,
                    height: 40.w,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 14.w),
                  child: Text(
                    item.name ?? '',
                    style: TextStyle(
                      color: ConfigStore.to.isDarkTheme.value ? Colors.white70 : AppColors.thirdElement,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image(
                    image: const AssetImage('assets/icons/ang.png'),
                    width: 15.w,
                    height: 15.w,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: Obx(() => Container(
            color: ConfigStore.to.isDarkTheme.value ? Colors.black : Colors.white,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
                  sliver: SliverToBoxAdapter(
                    child: controller.state.headDetail.value == null
                        ? Container()
                        : headItemWidget(controller.state.headDetail.value!),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      var item = controller.state.meListItem[index];
                      return meItem(item);
                    }, childCount: controller.state.meListItem.length),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
