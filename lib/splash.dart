import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodfornothing/screens/Auth/login.dart';
import 'package:foodfornothing/screens/DonerHome/drawer_screen.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/main.dart';

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);
  ///////

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.red,
                Colors.blue,
                Colors.cyanAccent,
                Colors.lightGreenAccent
              ],
            ),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(
                  child: Center(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/PDA.jpg'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text('Food For Nothing 🥣🌮🍗',
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                  ),
                )
              ]),
        ),
        backgroundColor: AppColor.primaryColor,
        splashTransition: SplashTransition.fadeTransition,
        duration: 3000,
        nextScreen: FirebaseAuth.instance.currentUser != null &&
                prefs.getString("userType") == 'Doner'
            ? FlutterZoomDrawerPage()
            : FirebaseAuth.instance.currentUser != null &&
                    prefs.getString("userType") == 'Donee'
                ? FlutterZoomDrawerPage()
                : loginPage(),
      ),
    );
  }
}
