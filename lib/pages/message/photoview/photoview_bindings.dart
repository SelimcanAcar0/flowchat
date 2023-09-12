import 'package:get/get.dart';

import 'photoview_controller.dart';

class PhotoImageViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhotoImageViewController>(() => PhotoImageViewController());
  }
}
