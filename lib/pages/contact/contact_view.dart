import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common/values/values.dart';
import '../../common/widgets/app.dart';
import 'contact_controller.dart';
import 'widgets/contact_list.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppBar buildAppBar() {
      return customAppBar(
          title: Text(
        'contact'.tr,
        style: TextStyle(color: AppColors.primaryBackground, fontSize: 18.sp, fontWeight: FontWeight.w600),
      ));
    }

    return Scaffold(
      appBar: buildAppBar(),
      body: const ContactList(),
    );
  }
}
