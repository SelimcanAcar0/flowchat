import 'package:flowchat/common/store/config.dart';
import 'package:flowchat/common/style/color.dart';
import 'package:flowchat/pages/message/chat/widgets/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/values/values.dart';
import 'chat_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({Key? key}) : super(key: key);

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: ConfigStore.to.isDarkTheme.value
                ? AppColor.darkGradient
                : AppColor.lightGradient),
      ),
      title: Container(
        padding: EdgeInsets.only(top: 0.w, bottom: 0.w, right: 0.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(top: 0.w, bottom: 0.w, right: 0.w),
              child: InkWell(
                child: SizedBox(
                  width: 44.w,
                  height: 44.w,
                  child: CachedNetworkImage(
                    imageUrl: controller.state.toAvatar.value,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 44.w,
                      width: 44.w,
                      margin: null,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(44.w)),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                    ),
                    errorWidget: (context, url, error) => const Image(
                      image: AssetImage('assets/images/feature-1.png'),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 15.w,
            ),
            Container(
              width: 180.w,
              padding: EdgeInsets.only(top: 0.w, bottom: 0.w, right: 0.w),
              child: Row(
                children: [
                  SizedBox(
                    width: 180.w,
                    height: 44.w,
                    child: GestureDetector(
                      onTap: () {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.state.toName.value,
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: 'Avenir',
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBackground,
                                fontSize: 16.sp),
                          ),
                          Obx(() => Text(
                                controller.state.toLocation.value,
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                style: TextStyle(
                                    fontFamily: 'Avenir',
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.primaryBackground,
                                    fontSize: 14.sp),
                              ))
                        ],
                      ),
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

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    controller.imgFromGallery();
                    Get.back();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {},
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(
          child: ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: Stack(
              children: [
                const ChatList(),
                Positioned(
                  bottom: 0.h,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: 360.w, minHeight: 50.h, maxHeight: 400.h),
                    child: Container(
                      padding: EdgeInsets.only(bottom: 5.h),
                      color: ConfigStore.to.isDarkTheme.value
                          ? Colors.black
                          : AppColors.chatbg,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 5.h),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(36)),
                            gradient: !ConfigStore.to.isDarkTheme.value
                                ? AppColor.lightGradient
                                : AppColor.darkGradient),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 230.w,
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: ConstrainedBox(
                                  constraints:
                                      BoxConstraints.loose(Size.infinite),
                                  child: TextField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 3,
                                    controller: controller.textController,
                                    autofocus: false,
                                    focusNode: controller.contentNode,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hoverColor: Colors.amber,
                                        hintText: 'Send messages...'),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              child: Icon(
                                Icons.photo_outlined,
                                size: 32.w,
                              ),
                              onTap: () {
                                _showPicker(context);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.send,
                              ),
                              onPressed: () {
                                controller.sendMessage();
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
