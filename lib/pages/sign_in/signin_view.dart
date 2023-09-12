import 'package:flowchat/common/store/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
import 'signin_controller.dart';

class SignInPage extends GetView<SignInController> {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            ConfigStore.to.isDarkTheme.value ? Colors.black : Colors.white,
        body: Center(
          child: Column(
            children: [
              _buildLogo(),
              const Spacer(),
              _buildThirdPartyLogin(),
            ],
          ),
        ));
  }

  Widget _buildLogo() {
    return Container(
      width: 110.w,
      margin: EdgeInsets.only(top: 84.h),
      child: Column(
        children: [
          Container(
            width: 76.w,
            height: 76.w,
            margin: EdgeInsets.symmetric(horizontal: 15.w),
            child: Stack(
              children: [
                Positioned(
                    child: Container(
                  height: 76.w,
                  decoration: const BoxDecoration(
                      boxShadow: [Shadows.primaryShadow],
                      borderRadius: BorderRadius.all(Radius.circular(35))),
                )),
                Positioned(
                    child: Image.asset(
                  'assets/images/ic_launcher.png',
                  width: 76.w,
                  height: 76.w,
                  fit: BoxFit.cover,
                ))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15.h, bottom: 15.h),
            child: Text(
              'letschat'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 18.sp, height: 1),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildThirdPartyLogin() {
    return Container(
      width: 295.w,
      margin: EdgeInsets.only(bottom: 220.h),
      child: Column(
        children: [
          Text(
            'signinwith'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.h, left: 50.w, right: 50.w),
            child: btnFlatButtonWidget(
                onPressed: () {
                  controller.handleSignIn();
                },
                width: 200.w,
                height: 40.h,
                title: 'googleLogin'.tr),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.h, left: 50.w, right: 50.w),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Banner(
                location: BannerLocation.topEnd,
                message: 'disabled'.tr,
                child: btnFlatButtonWidget(
                    onPressed: () {},
                    width: 200.w,
                    height: 40.h,
                    title: 'facebookLogin'.tr),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.h, left: 50.w, right: 50.w),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Banner(
                location: BannerLocation.topEnd,
                message: 'disabled'.tr,
                child: btnFlatButtonWidget(
                    onPressed: () {},
                    width: 200.w,
                    height: 40.h,
                    title: 'appleLogin'.tr),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
