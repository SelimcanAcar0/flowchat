import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../store/config.dart';
import '../style/color.dart';
import '../values/values.dart';

///  AppBar
AppBar customAppBar({
  Widget? title,
  Widget? leading,
  List<Widget>? actions,
}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    flexibleSpace: Container(
      decoration: BoxDecoration(
          gradient: ConfigStore.to.isDarkTheme.value
              ? AppColor.darkGradient
              : AppColor.lightGradient),
    ),
    centerTitle: true,
    title: title,
    leading: leading,
    actions: actions,
  );
}

Widget divider10Px({Color bgColor = AppColors.secondaryElement}) {
  return Container(
    height: 10.w,
    decoration: BoxDecoration(
      color: bgColor,
    ),
  );
}
