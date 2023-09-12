// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import '../../../common/entities/entities.dart';
import '../../../common/store/store.dart';
import '../../../common/utils/utils.dart';
import 'chat_index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatController extends GetxController {
  ChatController();
  ChatState state = ChatState();
  var docId;
  final textController = TextEditingController();
  ScrollController msgScrolling = ScrollController();
  FocusNode contentNode = FocusNode();
  final userId = UserStore.to.token;
  var userProfile = UserStore.to.profile;
  final db = FirebaseFirestore.instance;
  var listener;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  get http => null;

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile();
    } else {
      print('No image selected');
    }
  }

  Future getImgUrl(String name) async {
    print('...my image name is $name..');
    final spaceRef = FirebaseStorage.instance.ref('chat').child(name);
    var str = await spaceRef.getDownloadURL();
    return str;
  }

  sendImageMessage(String url) async {
    final content = Msgcontent(
        uid: userId, content: url, type: 'image', addtime: Timestamp.now());

    await FirebaseFirestore.instance
        .collection('message')
        .doc(docId)
        .collection('msglist')
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msgcontent, options) =>
                msgcontent.toFirestore())
        .add(content)
        .then((DocumentReference doc) {
      print('Document snapshot added with id, ${doc.id}');
    });
    await FirebaseFirestore.instance
        .collection('message')
        .doc(docId)
        .update({'last_msg': '【image】', 'last_time': Timestamp.now()});
    var userbase = await FirebaseFirestore.instance
        .collection('users')
        .withConverter(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userdata, options) => userdata.toFirestore(),
        )
        .where('id', isEqualTo: state.toUid.value)
        .get();
    if (userbase.docs.isEmpty) {
      var title = 'Message made by ${userProfile.displayName}';
      var body = '【image】';
      var token = userbase.docs.first.data().fcmtoken;
      if (token != null) {
        sendNotification(title, body, token);
      }
    }
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = getRandomString(15) + extension(_photo!.path);
    try {
      final ref = FirebaseStorage.instance.ref('chat').child(fileName);

      ref.putFile(_photo!).snapshotEvents.listen((event) async {
        switch (event.state) {
          case TaskState.running:
            print('...uploading file $fileName');

          case TaskState.paused:
            print('...uploading file paused $fileName');
            break;
          case TaskState.success:
            print('...uploading file succeed $fileName');
            String imgUrl = await getImgUrl(fileName);
            sendImageMessage(imgUrl);
            break;
          case TaskState.error:
            print('...uploading file error $fileName');
            // ...
            //toastInfo(msg:"upload image error");
            break;
          case TaskState.canceled:
            print('...uploading file canceled $fileName');
            break;
        }
      });
    } catch (e) {
      print("There's an error $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    print(data);
    docId = data['doc_id'] ?? '';
    state.toUid.value = data['to_uid'] ?? '';
    state.toName.value = data['to_name'] ?? '';
    state.toAvatar.value = data['to_avatar'] ?? '';
  }

  sendMessage() async {
    String sendContent = textController.text;
    final content = Msgcontent(
        uid: userId,
        content: sendContent,
        type: 'text',
        addtime: Timestamp.now());
    if (sendContent.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('message')
          .doc(docId)
          .collection('msglist')
          .withConverter(
              fromFirestore: Msgcontent.fromFirestore,
              toFirestore: (Msgcontent msgcontent, options) =>
                  msgcontent.toFirestore())
          .add(content)
          .then((DocumentReference doc) {
        print('Document snapshot added with id, ${doc.id}');
        textController.clear();
      });
      await FirebaseFirestore.instance
          .collection('message')
          .doc(docId)
          .update({'last_msg': sendContent, 'last_time': Timestamp.now()});
      //  var fcmid = await db.collection("users").where("id", isEqualTo: state.to_uid.value).get();
      var userbase = await FirebaseFirestore.instance
          .collection('users')
          .withConverter(
            fromFirestore: UserData.fromFirestore,
            toFirestore: (UserData userdata, options) => userdata.toFirestore(),
          )
          .where('id', isEqualTo: state.toUid.value)
          .get();

      print('userbase-------');
      print(userbase.docs.first.data());
      if (userbase.docs.isNotEmpty) {
        var title = 'Message made by ${userProfile.displayName}';
        var body = sendContent;
        var token = userbase.docs.first.data().fcmtoken;
        print(token);
        if (token != null) {
          sendNotification(title, body, token);
        }
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    var messages = FirebaseFirestore.instance
        .collection('message')
        .doc(docId)
        .collection('msglist')
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msgcontent, options) =>
                msgcontent.toFirestore())
        .orderBy('addtime', descending: false);
    state.msgcontentList.clear();
    listener = messages.snapshots().listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            if (change.doc.data() != null) {
              state.msgcontentList.insert(0, change.doc.data()!);
            }
            break;
          case DocumentChangeType.modified:
            break;

          case DocumentChangeType.removed:
            break;
        }
      }
    }, onError: (error) => print('Listen failed:  $error'));

    getLocation();
  }

  getLocation() async {
    try {
      var userLocation = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: state.toUid.value)
          .withConverter(
              fromFirestore: UserData.fromFirestore,
              toFirestore: (UserData userdata, options) =>
                  userdata.toFirestore())
          .get();
      var location = userLocation.docs.first.data().location;
      if (location != '') {
        state.toLocation.value = location ?? 'unknown';
      } else {}
    } catch (e) {
      print('We have error $e');
    }
  }

  Future<void> sendNotification(String title, String body, String token) async {
    const String url = 'https://fcm.googleapis.com/fcm/send';
    var iosNotification = {
      'data': {
        'doc_id': '$docId',
        'to_uid': userId,
        'to_name': '${userProfile.displayName}',
        'to_avatar': '${userProfile.photoUrl}'
      },
      'notification': {
        'body': body,
        'title': title,
        'content_available': true,
        'mutable_content': true,
        'sound': 'task_cancel.caf',
        'badge': 1
      },
      'to': token
    };
    String iosNotificationJson = jsonEncode(iosNotification);

    // android
    var androidNotification = {
      'data': {
        'doc_id': '$docId',
        'to_uid': userId,
        'to_name': '${userProfile.displayName}',
        'to_avatar': '${userProfile.photoUrl}'
      },
      'notification': {
        'body': body,
        'title': title,
        'android_channel_id': 'com.dbestech.letschat1',
        'sound': 'default',
      },
      'to': token
    };

    String androidNotificationJson = jsonEncode(androidNotification);
    // String notification = '{"notification": {"body": "$body", '
    //     '"title": "$title",'
    //     ' "content_available": "true"},'
    //     ' "priority": "high", '
    //     ' "to": "$token",'
    //     ' "sound":"default",'
    //     ' "data":{"to_uid": "$userId", '
    //     ' "doc_id": "$docId", '
    //     ' "to_name": "${userProfile.displayName}", '
    //     ' "to_avatar": "${userProfile.photoUrl}"}, '
    //     '}';
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Keep-Alive': 'timeout=5',
          'Authorization':
              'key=AAAAUowPRnI:APA91bE_oiOwbO17ymwzx4bryWViMlO3hTzukVOEcWP-Qqf8yU-eL9i_Joqs6KpaFTYF_Rll6uyi4oZ5ddfwgD4tpphFSzHJTDEYLdjz5S0mDsBl40Yy0IcZVJgNmOiGUxsvLu8AwUcx'
        },
        body:
            GetPlatform.isIOS ? iosNotificationJson : androidNotificationJson);
    print(response.body);
  }

  @override
  void dispose() {
    msgScrolling.dispose();
    listener.cancel();
    super.dispose();
  }
}
