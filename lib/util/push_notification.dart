// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class PushNotification {
  BuildContext context;
  AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAMHXi_o4:APA91bHXOPshZI5m1KvgIgsnW8oPCqj_KrCC-9YeW2im1qL4yMh9xh3fUmFmw-kl9c2oGOx6GtcEHloLGPzwUPg8LtbUW2behjvNBOidIxbB5XY2U6rvfWniQhiaXlScAPbJuLyEHErN',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
      print("send push notification sucessfully");
      initInfo(context);
    } catch (e) {
      if (kDebugMode) {
        print("error push notification");
      }
    }
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('User granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('User declined or has not accepted permission');
      }
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        BigTextStyleInformation bigTextStyleInformation =
            BigTextStyleInformation(
          message.notification.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification.title.toString(),
          htmlFormatContentTitle: true,
        );
        AndroidNotificationDetails androidNotificationDetails =
            AndroidNotificationDetails(
          'foodfornothing',
          'foodfornothing',
          importance: Importance.high,
          styleInformation: bigTextStyleInformation,
          priority: Priority.high,
          playSound: true,
        );
        NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails,
          iOS: const IOSNotificationDetails(),
        );
        await FlutterLocalNotificationsPlugin().show(
          0,
          message.notification.title.toString(),
          message.notification.body.toString(),
          notificationDetails,
          payload: message.data['body'],
        );
        // flutterLocalNotificationsPlugin.show(
        //   notification.hashCode,
        //   notification.title,
        //   notification.body,
        //   // NotificationDetails(
        //   //   android: AndroidNotificationDetails(
        //   //     channel.id,
        //   //     channel.name,
        //   //     // icon: 'launch_background',
        //   //   ),
        //   // ),
        // );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void initInfo(BuildContext context) {
    var androidInitlize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var IOSInitialize = const IOSInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitlize, iOS: IOSInitialize);
    FlutterLocalNotificationsPlugin().initialize(
      initializationsSettings,
      onSelectNotification: (String payload) async {
        try {
          if (payload != null && payload.isNotEmpty) {
            //
          } else {
            //
          }
        } catch (e) {
          //
        }
        return;
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('__________________onMessage________________');
      print(
          'onMessage : ${message.notification.title}/${message.notification.body}');
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'foodfornothing',
        'foodfornothing',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
      );
      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: const IOSNotificationDetails(),
      );

      await FlutterLocalNotificationsPlugin().show(
        0,
        message.notification.title.toString(),
        message.notification.body.toString(),
        notificationDetails,
        payload: message.data['body'],
      );
    });
  }
}
