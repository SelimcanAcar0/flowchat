import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../common/entities/msg.dart';
import '../../../../common/store/config.dart';
import '../../../../common/utils/utils.dart';
import '../../../../common/values/colors.dart';
import '../../index.dart';

class MessageList extends GetView<MessageController> {
  const MessageList({Key? key}) : super(key: key);

  Widget messageListItem(QueryDocumentSnapshot<Msg> item) {
    return Container(
      padding: EdgeInsets.only(top: 10.w, left: 15.w, right: 15.w),
      child: InkWell(
        onTap: () {
          var toUid = '';
          var toName = '';
          var toAvatar = '';
          if (item.data().fromUid == controller.token) {
            toUid = item.data().toUid ?? '';
            toName = item.data().toName ?? '';
            toAvatar = item.data().toAvatar ?? '';
          } else {
            toUid = item.data().fromUid ?? '';
            toName = item.data().fromName ?? '';
            toAvatar = item.data().fromAvatar ?? '';
          }
          Get.toNamed('/chat', parameters: {
            'doc_id': item.id,
            'to_uid': toUid,
            'to_name': toName,
            'to_avatar': toAvatar
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 0.w, left: 0.w, right: 15.w),
              child: SizedBox(
                width: 54.w,
                height: 54.w,
                child: CachedNetworkImage(
                  imageUrl: item.data().fromUid == controller.token
                      ? item.data().toAvatar!
                      : item.data().fromAvatar!,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 54.w,
                    height: 54.w,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(54)),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover)),
                  ),
                  errorWidget: (context, url, error) => const Image(
                      image: AssetImage('assets/images/flowchaticon.png')),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 0.w, left: 0.w, right: 5.w),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 180.w,
                    height: 48.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.data().fromUid == controller.token
                              ? item.data().toName!
                              : item.data().fromName!,
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.bold,
                              color: ConfigStore.to.isDarkTheme.value
                                  ? Colors.white70
                                  : AppColors.thirdElement,
                              fontSize: 16.sp),
                        ),
                        Text(
                          item.data().lastMsg ?? '',
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.normal,
                              color: ConfigStore.to.isDarkTheme.value
                                  ? Colors.white60
                                  : AppColors.thirdElement,
                              fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 60.w,
                    height: 54.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          duTimeLineFormat(
                              (item.data().lastTime as Timestamp).toDate()),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.normal,
                              color: AppColors.thirdElementText,
                              fontSize: 12.sp),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: ConfigStore.to.isDarkTheme.value ? Colors.black : Colors.white,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    var item = controller.state.msgList[index];
                    return messageListItem(item);
                  }, childCount: controller.state.msgList.length),
                ),
              ),
            ],
          ),
        ));
  }
}
