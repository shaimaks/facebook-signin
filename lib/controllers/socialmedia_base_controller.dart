
import 'dart:convert';

import 'package:facebook_sign_in_sample/widgets/common_scaffold.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../fcm_repository.dart';


class SocialmediaBaseController extends GetxController {
  static SocialmediaBaseController get to =>
      Get.put<SocialmediaBaseController>(SocialmediaBaseController());
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  final FirebaseAuth _auth = FirebaseAuth.instance;


  init() {
    fcmInit();
  }
  void fcmInit(){
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    FcmRepository(firebaseMessaging: _firebaseMessaging).firebaseCloudMessaging_Listeners();
    // FirebaseInAppMessaging fiam = FirebaseInAppMessaging();
    // fiam.triggerEvent('app_launch');

  }

  Future<Null> facebookLogin() async {


    final FacebookLoginResult result = await facebookSignIn
        .logIn(['email', 'public_profile', 'user_friends']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        print('''
       Logged in!

       FBToken: ${accessToken.token}
       User id: ${accessToken.userId}
       Expires: ${accessToken.expires}
       Permissions: ${accessToken.permissions}
       Declined permissions: ${accessToken.declinedPermissions}
       ''');
        var graphResponse = await http.get(
       'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${accessToken.token}');

        var profile = json.decode(graphResponse.body);
        print("test fb profile ${profile.toString()}");
        AuthCredential authCredential =
        FacebookAuthProvider.credential(accessToken.token);
        User fbUser;
        fbUser = (await _auth.signInWithCredential(authCredential)).user;
        print("got fb details");
        var data=   await   fbUser.getIdToken().then((value) async {

          Dialogs.showLoadingDialog("Logging in...");
          var response = await http.get(
              'https://graph.facebook.com/v2.11/${accessToken.userId}/?fields=friends{name,id}&access_token=${accessToken.token}');
          var friendprofile = json.decode(response.body);
          print("test fb friendprofile ${friendprofile.toString()}");




        });
        break;



      case FacebookLoginStatus.cancelledByUser:
        Get.back();
        print('Login cancelled by the user.');
        showSnackbar("", "Login cancelled by the user...");

        // Dialogs.showLoadingDialog('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        Get.back();
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        showSnackbar("", "Something went wrong with the login process...");

               break;
    }
  }
  Future<Null> facebookLogout() async {
    await facebookSignIn.logOut();
    print('Logged out.');
  }

}
