import 'package:flowchat/pages/profile/settings/setting_index.dart';
import 'package:flowchat/pages/welcome/welcome_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dots_indicator/dots_indicator.dart';

class WelcomePage extends GetView<WelcomeController> {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        var imagePath1 = 'assets/images/flowchatwelcomeicon.png';
        var imagePath2 = 'assets/images/banner3.png';
        return SizedBox(
          width: 360.w,
          height: 780.w,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SafeArea(
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  reverse: false,
                  onPageChanged: (index) {
                    controller.changePage(index);
                  },
                  controller: PageController(initialPage: 0, keepPage: false, viewportFraction: 1),
                  pageSnapping: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    pageViewImage(
                        imagePath: imagePath1,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                                bottom: 120,
                                child: Text(
                                  'hellouser'.tr,
                                  style: const TextStyle(color: Colors.white, fontSize: 30),
                                )),
                          ],
                        )),
                    const SettingPage(),
                    pageViewImage(
                      imagePath: imagePath2,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [Positioned(bottom: 90, child: loginNavigatorButton())],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(bottom: 70, child: pageDotsIndicator())
            ],
          ),
        );
      }),
    );
  }

  DotsIndicator pageDotsIndicator() {
    return DotsIndicator(
      position: controller.state.index.value,
      dotsCount: 3,
      reversed: false,
      mainAxisAlignment: MainAxisAlignment.center,
      decorator: DotsDecorator(
          size: const Size.square(9),
          activeSize: const Size(18.0, 9.0),
          activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
    );
  }

  ElevatedButton loginNavigatorButton() {
    return ElevatedButton(
      onPressed: () {
        controller.handleSignIn();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          foregroundColor: MaterialStateProperty.all(Colors.black),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          side: MaterialStateProperty.all(const BorderSide(color: Colors.white))),
      child: Text('login'.tr),
    );
  }

  Container pageViewImage({required String imagePath, Widget? child}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: AssetImage(imagePath))),
      child: child,
    );
  }
}
