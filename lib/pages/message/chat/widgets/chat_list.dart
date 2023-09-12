import 'package:flowchat/pages/message/chat/widgets/chat_right_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/store/config.dart';
import '../../../../common/values/values.dart';
import '../chat_index.dart';
import 'chat_left_item.dart';

class ChatList extends GetView<ChatController> {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: ConfigStore.to.isDarkTheme.value ? Colors.black : AppColors.chatbg,
          padding: EdgeInsets.only(bottom: 50.h),
          child: CustomScrollView(
            reverse: true,
            controller: controller.msgScrolling,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    var item = controller.state.msgcontentList[index];
                    if (controller.userId == item.uid) {
                      return chatRightItem(item);
                    }
                    return chatLeftItem(item);
                  }, childCount: controller.state.msgcontentList.length),
                ),
              )
            ],
          ),
        ));
  }
}
