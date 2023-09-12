import 'package:flowchat/pages/profile/account/account_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/values/colors.dart';
import '../../../common/widgets/app.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: const Column(children: [
          Card(
            elevation: 100,
            child: Row(children: [
                

            ],),
          ),
          
        ]),
      ),
    );
  }
}

AppBar _buildAppBar() {
  return customAppBar(
      title: Text(
    'account'.tr,
    style: TextStyle(
        color: AppColors.primaryBackground,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600),
  ));
}
