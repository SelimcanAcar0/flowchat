import 'package:get/get.dart';

import '../../common/entities/entities.dart';

class ContactState {
  var count = 0.obs;
  RxList<UserData> contactList = <UserData>[].obs;
}
