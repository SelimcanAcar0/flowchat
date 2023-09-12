import 'package:flutter/material.dart';

class AppColor {
  static const Color scaffoldBackground = Color(0xFFFFFFFF);

  static const Color primaryText = Color(0xFF333333);

  static const Color secondaryText = Color(0xFF74788D);

  static const Color accentColor = Color(0xFF5C78FF);

  static const Color secondaryColor = Color(0xFFDEE3FF);

  static const Color warnColor = Color(0xFFFFB822);

  static const Color borderColor = Color(0xFFDEE3FF);

  static const Color pinkColor = Color(0xFFF77866);

  static const Color yellowColor = Color(0xFFFFB822);

  static const LinearGradient lightGradient = LinearGradient(colors: [
    Color.fromARGB(255, 76, 161, 175),
    Color.fromARGB(255, 196, 224, 229),
  ], transform: GradientRotation(90));

  static const LinearGradient darkGradient = LinearGradient(colors: [
    Color.fromARGB(255, 233, 100, 67),
    Color.fromARGB(255, 144, 78, 149),
  ], transform: GradientRotation(90));
}
