import 'package:get/get.dart';

import '../../common/entities/entities.dart';

class ProfileState {
  var headDetail = Rx<UserLoginResponseEntity?>(null);
  RxList<MeListItem> meListItem = <MeListItem>[].obs;
}
