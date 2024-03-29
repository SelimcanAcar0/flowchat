import 'package:get/get.dart';

import '../contact/contact_controller.dart';
import '../message/message_controller.dart';
import '../profile/profile_controller.dart';
import 'application_controller.dart';

class ApplicationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationController>(() => ApplicationController());
    Get.lazyPut<ContactController>(() => ContactController());
    Get.lazyPut<MessageController>(() => MessageController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
