// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:foodfornothing/components/components.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/main.dart';
import 'package:foodfornothing/screens/DoneeHome/pages/Monitor/Monitor.dart';
import 'package:foodfornothing/screens/DonerHome/Pages/About_Us.dart';
import 'package:foodfornothing/screens/profile_page.dart';
import 'package:foodfornothing/splash.dart';

class DoneeMenuScreenPage extends StatefulWidget {
  const DoneeMenuScreenPage({Key key}) : super(key: key);

  @override
  State<DoneeMenuScreenPage> createState() => _DoneeMenuScreenPageState();
}

class _DoneeMenuScreenPageState extends State<DoneeMenuScreenPage> {
  var userData;

  getCuttentUserData() async {
    userData = await FirebaseFirestore.instance
        .collection(prefs.getString("userType"))
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null && userData == null) {
      getCuttentUserData();
    }
    return userData != null
        ? SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColor.primaryColor,
                            radius: 50,
                            backgroundImage: userData['profileImageLink'] != '0'
                                ? NetworkImage(
                                    userData['profileImageLink'],
                                  )
                                : Image.asset(
                                    Components.showPersonIcon(context),
                                    fit: BoxFit.fill,
                                  ).image,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: Text(
                              userData['userName'],
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              userData['userEmail'],
                              style: TextStyle(
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          onTap: () {
                            ZoomDrawer.of(context).close();
                          },
                          leading: const Icon(
                            FontAwesome.home,
                          ),
                          title: Text(
                            'Dashboard',
                            style: TextStyle(
                              color: AppColor.blackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: const Duration(seconds: 1),
                                transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secAnimation,
                                    Widget child) {
                                  animation = CurvedAnimation(
                                      parent: animation, curve: Curves.linear);
                                  return SharedAxisTransition(
                                      animation: animation,
                                      secondaryAnimation: secAnimation,
                                      transitionType:
                                          SharedAxisTransitionType.horizontal,
                                      child: child);
                                },
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secAnimation) {
                                  return const DoneeMonitorPage();
                                },
                              ),
                            );
                          },
                          leading: const Icon(
                            FontAwesome.search,
                          ),
                          title: Text(
                            'Monitor',
                            style: TextStyle(
                              color: AppColor.blackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: const Duration(seconds: 1),
                                transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secAnimation,
                                    Widget child) {
                                  animation = CurvedAnimation(
                                      parent: animation, curve: Curves.linear);
                                  return SharedAxisTransition(
                                      animation: animation,
                                      secondaryAnimation: secAnimation,
                                      transitionType:
                                          SharedAxisTransitionType.horizontal,
                                      child: child);
                                },
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secAnimation) {
                                  return AboutUsPage();
                                },
                              ),
                            );
                          },
                          leading: const Icon(
                            FontAwesome.info_circle,
                          ),
                          title: Text(
                            'About Us',
                            style: TextStyle(
                              color: AppColor.blackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: const Duration(seconds: 1),
                                transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secAnimation,
                                    Widget child) {
                                  animation = CurvedAnimation(
                                      parent: animation, curve: Curves.linear);
                                  return SharedAxisTransition(
                                      animation: animation,
                                      secondaryAnimation: secAnimation,
                                      transitionType:
                                          SharedAxisTransitionType.horizontal,
                                      child: child);
                                },
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secAnimation) {
                                  return const ProfilePage();
                                },
                              ),
                            );
                          },
                          leading: const Icon(
                            Icons.person,
                          ),
                          title: Text(
                            'Profile',
                            style: TextStyle(
                              color: AppColor.blackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            CoolAlert.show(
                              context: context,
                              backgroundColor: AppColor.primaryColor,
                              confirmBtnColor: AppColor.primaryColor,
                              barrierDismissible: false,
                              type: CoolAlertType.confirm,
                              text: 'you want to Logout?',
                              onConfirmBtnTap: () async {
                                Components.showAlertDialog(context);
                                await FirebaseAuth.instance
                                    .signOut()
                                    .whenComplete(() {
                                  Timer(const Duration(seconds: 3), () {
                                    prefs.clear();
                                    Navigator.of(context).pushAndRemoveUntil(
                                      PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(seconds: 1),
                                        transitionsBuilder:
                                            (BuildContext context,
                                                Animation<double> animation,
                                                Animation<double> secAnimation,
                                                Widget child) {
                                          animation = CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.linear);
                                          return SharedAxisTransition(
                                              animation: animation,
                                              secondaryAnimation: secAnimation,
                                              transitionType:
                                                  SharedAxisTransitionType
                                                      .horizontal,
                                              child: child);
                                        },
                                        pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double> secAnimation) {
                                          return const Splash();
                                        },
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                  });
                                });
                              },
                              confirmBtnText: 'Logout',
                              showCancelBtn: true,
                            );
                          },
                          leading: const Icon(
                            Icons.power_settings_new,
                            color: Colors.red,
                          ),
                          title: const Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          )
        : Center(
            child: CircularProgressIndicator(
              color: AppColor.primaryColor,
            ),
          );
  }
}
