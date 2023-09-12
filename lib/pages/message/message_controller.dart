import 'package:flowchat/common/utils/http.dart';
import 'package:flowchat/pages/message/index.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../common/entities/entities.dart';
import '../../common/store/store.dart';

class MessageController extends GetxController {
  MessageController();
  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final MessageState state = MessageState();

  final RefreshController refreshController = RefreshController(initialRefresh: true);

  @override
  void onReady() {
    super.onReady();
    getUserLocation();
    getFcmToken();
    snapshotsListen();
  }

  asyncLoadAllData() async {
    var fromMessage = await db
        .collection('message')
        .withConverter(fromFirestore: Msg.fromFirestore, toFirestore: (Msg msg, options) => msg.toFirestore())
        .where('from_uid', isEqualTo: token)
        .get();

    var toMessages = await db
        .collection('message')
        .withConverter(fromFirestore: Msg.fromFirestore, toFirestore: (Msg msg, options) => msg.toFirestore())
        .where('to_uid', isEqualTo: token)
        .get();
    state.msgList.clear();
    if (fromMessage.docs.isNotEmpty) {
      state.msgList.addAll(fromMessage.docs);
    }

    if (toMessages.docs.isNotEmpty) {
      state.msgList.addAll(toMessages.docs);
    }
    // sort
    state.msgList.sort((a, b) {
      if (b.data().lastTime == null) {
        return 0;
      }
      if (a.data().lastTime == null) {
        return 0;
      }
      return b.data().lastTime!.compareTo(a.data().lastTime!);
    });
  }

  snapshotsListen() async {
    var fromMessage = db
        .collection('message')
        .withConverter(fromFirestore: Msg.fromFirestore, toFirestore: (Msg msg, options) => msg.toFirestore())
        .where('from_uid', isEqualTo: token);
    fromMessage.snapshots().listen((event) {
      asyncLoadAllData();
    }, onError: (error) => print('Listen failed:  $error'));
    var toMessages = db
        .collection('message')
        .withConverter(fromFirestore: Msg.fromFirestore, toFirestore: (Msg msg, options) => msg.toFirestore())
        .where('to_uid', isEqualTo: token);
    toMessages.snapshots().listen((event) {
      asyncLoadAllData();
    }, onError: (error) => print('Listen failed:  $error'));
  }

  getUserLocation() async {
    try {
      final location = await Location().getLocation();
      String address = '${location.latitude}, ${location.longitude}';
      String url =
          'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=AIzaSyCMESvjp3G5FtPnukZ28_GVOuFSvEhSS9c';
      var response = await HttpUtil().get(url);
      MyLocation locationRes = MyLocation.fromJson(response);
      if (locationRes.status == 'OK') {
        String? myaddresss = locationRes.results?.first.formattedAddress;
        if (myaddresss != null) {
          var userLocation = await db.collection('users').where('id', isEqualTo: token).get();
          if (userLocation.docs.isNotEmpty) {
            var docId = userLocation.docs.first.id;
            await db.collection('users').doc(docId).update({'location': myaddresss});
          }
        }
      }
    } catch (e) {
      print('Getting error $e');
    }
  }

  getFcmToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('...my token is $fcmToken...');
    if (fcmToken != null) {
      var user = await db.collection('users').where('id', isEqualTo: token).get();
      if (user.docs.isNotEmpty) {
        var docId = user.docs.first.id;
        await db.collection('users').doc(docId).update({'fcmtoken': fcmToken});
      }
    }
    await FirebaseMessaging.instance.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('..................onMessage................');
      print('onMessage: ${message.notification?.title}/${message.notification?.body}');
      print('message.data------------');
      print(message.data);
      //   HelperNotification.showNotification(message.notification!.title!, message.notification!.body!);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onOpenApp: ${message.notification?.title}/${message.notification?.body}');
      print('message.data------------');
      print(message.data);
      var toUid = message.data['to_uid'];
      var toName = message.data['to_name'];
      var toAvatar = message.data['to_avatar'];
      var docId = message.data['doc_id'];
      Get.toNamed('/chat', parameters: {'doc_id': docId, 'to_uid': toUid, 'to_name': toName, 'to_avatar': toAvatar});
    });
  }
}
