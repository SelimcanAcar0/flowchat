import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/values/values.dart';
import '../../common/widgets/app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'chat/widgets/message_list.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  AppBar _buildAppBar() {
    return customAppBar(
        title: Text(
      'chat'.tr,
      style: TextStyle(color: AppColors.primaryBackground, fontSize: 18.sp, fontWeight: FontWeight.w600),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: const MessageList(),
    );
  }
}
