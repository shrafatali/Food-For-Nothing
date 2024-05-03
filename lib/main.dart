// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foodfornothing/screens/Auth/login.dart';
import 'package:foodfornothing/screens/Auth/signup/choose.dart';
import 'package:foodfornothing/screens/Auth/signup/donee/donee.dart';
import 'package:foodfornothing/screens/Auth/signup/doners/donors.dart';
import 'package:foodfornothing/splash.dart';
import 'package:foodfornothing/util/routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;
final box = GetStorage();

DateTime date = DateTime.now();
String todayDateAndTime =
    '${date.year}-${date.month < 10 ? '0${date.month}' : date.month}-${date.day < 10 ? '0${date.day}' : date.day} ${date.hour < 10 ? '0${date.hour}' : date.hour}:${date.minute < 10 ? '0${date.minute}' : date.minute}:00';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  prefs = await SharedPreferences.getInstance();

  Stripe.publishableKey =
      'pk_test_51MxZqvE8lNghN5wBRYbsFGR7JXJ4gu1ufuaHpGOuTQvLd5oq7uGNOb02Y2JvJzGH3NM1VosvsPL1I4LmG3tj22Ph00JEgsxloe';

  if (FirebaseAuth.instance.currentUser != null &&
          prefs.getString('userType') == 'Donee' ||
      prefs.getString('userType') == 'Doner') {
    try {
      await FirebaseMessaging.instance.getToken().then((value) async {
        await FirebaseFirestore.instance
            .collection(prefs.getString("userType"))
            .doc(FirebaseAuth.instance.currentUser.uid)
            .update({'fcm_token': value}).whenComplete(() {
          prefs.setString('fcm_token', value);
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Food For Nothing',
      themeMode: ThemeMode.light,
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      initialRoute: "/splash",
      routes: {
        MyRoutes.loginRoute: (context) => loginPage(),
        MyRoutes.chooseRoute: (context) => choose(),
        MyRoutes.donorsRoute: (context) => const donors(),
        MyRoutes.doneeRoute: (context) => const donee(),
        MyRoutes.splash: (context) => const Splash()
      },
    );
  }
}
