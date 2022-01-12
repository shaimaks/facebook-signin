import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



class FcmRepository{
  FcmRepository({ this.firebaseMessaging});
   FirebaseMessaging firebaseMessaging;

   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // ignore: non_constant_identifier_names
  void firebaseCloudMessaging_Listeners() async {
    if (Platform.isIOS) iOS_Permission();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android =  AndroidInitializationSettings('@drawable/ic_launcher');
    var iOS =  IOSInitializationSettings();
    var initSetttings = InitializationSettings(android:android, iOS:iOS);
    // flutterLocalNotificationsPlugin.initialize(initSetttings,
    //     onSelectNotification: onSelectNotification);
    firebaseMessaging.getToken().then((token) async{
      print('fcm token : $token');

    });

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        showNotification(message['notification']['title'],message['notification']['body']);

      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        showNotification(message['notification']['title'],message['notification']['body']);

      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        showNotification(message['notification']['title'],message['notification']['body']);

      },
    );
  }

  void iOS_Permission() {
    firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
  // Future onSelectNotification(String payload) {
  //   debugPrint("payload : $payload");
  //
  //
  //
  //   // showDialog(
  //   //   context: Get.context,
  //   //   builder: (_) => new AlertDialog(
  //   //     title: new Text('Notification'),
  //   //     content: new Text('$payload'),
  //   //   ),
  //   // );
  // }
  showNotification(title,message) async {
    var android = new AndroidNotificationDetails(
      'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
      priority: Priority.high,importance: Importance.max,
      largeIcon: DrawableResourceAndroidBitmap("ic_launcher") ,
      ongoing: true,

      styleInformation: BigTextStyleInformation(''),

    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android:android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, '$title', '$message', platform,
        payload: 'AndroidCoding.in');
  }

}