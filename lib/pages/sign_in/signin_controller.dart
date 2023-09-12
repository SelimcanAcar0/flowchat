import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../common/entities/entities.dart';
import '../../common/routes/routes.dart';
import '../../common/store/store.dart';
import '../../common/widgets/widgets.dart';
import 'signin_index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final GoogleSignIn googleSignIn = GoogleSignIn(scopes: <String>['openid']);

class SignInController extends GetxController {
  static SignInController get to => SignInController();

  final state = SignInState();
  SignInController();
  final db = FirebaseFirestore.instance;

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<UserCredential> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    return await FirebaseAuth.instance.signInWithProvider(appleProvider);
  }

  Future<void> handleSignIn() async {
    try {
      var user = await googleSignIn.signIn();
      print('user-----------------');
      print(user);
      if (user != null) {
        final gAuthentication = await user.authentication;
        final credential =
            GoogleAuthProvider.credential(idToken: gAuthentication.idToken, accessToken: gAuthentication.accessToken);

        await FirebaseAuth.instance.signInWithCredential(credential);

        String displayName = user.displayName ?? user.email;
        String email = user.email;
        String id = user.id;
        String photoUrl = user.photoUrl ?? '';
        UserLoginResponseEntity userProfile = UserLoginResponseEntity();
        userProfile.email = email;
        userProfile.accessToken = id;
        userProfile.displayName = displayName;
        userProfile.photoUrl = photoUrl;
        userProfile.type = 'google';

        UserStore.to.saveProfile(userProfile);
        var userbase = await db
            .collection('users')
            .withConverter(
              fromFirestore: UserData.fromFirestore,
              toFirestore: (UserData userdata, options) => userdata.toFirestore(),
            )
            .where('id', isEqualTo: id)
            .get();

        if (userbase.docs.isEmpty) {
          final data = UserData(
              id: id,
              name: displayName,
              email: email,
              photourl: photoUrl,
              location: '',
              fcmtoken: '',
              addtime: Timestamp.now());
          await db
              .collection('users')
              .withConverter(
                fromFirestore: UserData.fromFirestore,
                toFirestore: (UserData userdata, options) => userdata.toFirestore(),
              )
              .add(data);
        }
        toastInfo(msg: 'login success');
        Get.offAndToNamed(
          AppRoutes.Application,
        );
      }
    } catch (e) {
      toastInfo(msg: 'login error');
      print(e);
    }
  }

  @override
  void onReady() {
    super.onReady();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently logged out');
      } else {
        print('User is logged in');
      }
    });
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
  }
}
