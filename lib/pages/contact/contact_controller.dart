import 'dart:convert';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/entities/entities.dart';
import '../../common/store/store.dart';
import 'contact_index.dart';

class ContactController extends GetxController {
  ContactController();
  final ContactState state = ContactState();
  final db = FirebaseFirestore.instance;
  final token = UserStore.to.token;

  @override
  void onReady() {
    super.onReady();
    asyncLoadAllData();
  }

  goChat(UserData toUserdata) async {
    print(toUserdata.id);
    var fromMessages = await db
        .collection('message')
        .withConverter(fromFirestore: Msg.fromFirestore, toFirestore: (Msg msg, options) => msg.toFirestore())
        .where('from_uid', isEqualTo: token) //and condition
        .where('to_uid', isEqualTo: toUserdata.id)
        .get();

    var toMessages = await db
        .collection('message')
        .withConverter(fromFirestore: Msg.fromFirestore, toFirestore: (Msg msg, options) => msg.toFirestore())
        .where('from_uid', isEqualTo: toUserdata.id)
        .where('to_uid', isEqualTo: token)
        .get();

    if (fromMessages.docs.isEmpty && toMessages.docs.isEmpty) {
      String profile = await UserStore.to.getProfile();
      UserLoginResponseEntity userdata = UserLoginResponseEntity.fromJson(jsonDecode(profile));
      var msgdata = Msg(
          fromUid: userdata.accessToken,
          toUid: toUserdata.id,
          fromName: userdata.displayName,
          toName: toUserdata.name,
          fromAvatar: userdata.photoUrl,
          toAvatar: toUserdata.photourl,
          lastMsg: '',
          lastTime: Timestamp.now(),
          msgNum: 0);
      db
          .collection('message')
          .withConverter(fromFirestore: Msg.fromFirestore, toFirestore: (Msg msg, options) => msg.toFirestore())
          .add(msgdata)
          .then((value) {
        Get.toNamed('/chat', parameters: {
          'doc_id': value.id,
          'to_uid': toUserdata.id ?? '',
          'to_name': toUserdata.name ?? '',
          'to_avatar': toUserdata.photourl ?? ''
        });
      });
    } else {
      if (fromMessages.docs.isNotEmpty) {
        Get.toNamed('/chat', parameters: {
          'doc_id': fromMessages.docs.first.id,
          'to_uid': toUserdata.id ?? '',
          'to_name': toUserdata.name ?? '',
          'to_avatar': toUserdata.photourl ?? ''
        });
      }
      if (toMessages.docs.isNotEmpty) {
        Get.toNamed('/chat', parameters: {
          'doc_id': toMessages.docs.first.id,
          'to_uid': toUserdata.id ?? '',
          'to_name': toUserdata.name ?? '',
          'to_avatar': toUserdata.photourl ?? ''
        });
      }
    }
  }

  asyncLoadAllData() async {
    var usersbase = await db
        .collection('users')
        .where('id', isNotEqualTo: token)
        .withConverter(
            fromFirestore: UserData.fromFirestore, toFirestore: (UserData userdata, options) => userdata.toFirestore())
        .get();

    for (var doc in usersbase.docs) {
      state.contactList.add(doc.data());
    }
  }
}
