// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:foodfornothing/screens/Auth/forget_password.dart';
import 'package:foodfornothing/screens/Auth/signup/choose.dart';
import 'package:foodfornothing/screens/DonerHome/drawer_screen.dart';
import 'package:foodfornothing/components/components.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/util/helper.dart';
import 'package:foodfornothing/main.dart';

class loginPage extends StatefulWidget {
  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  String selectedRole = 'Donee';
  String errorMessage;
  bool isPasswordVisible = true;

  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/user.png',
                  fit: BoxFit.cover,
                  height: 250,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  const WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Text(
                                      "Welcome ",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Text(
                                      '$selectedRole!',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: AppColor.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _selectRole(),
                          ],
                        ),
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.only(top: 20),
                        title: const Text('Email'),
                        subtitle: TextFormField(
                          controller: emailC,
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            prefixIcon: Icon(Icons.attach_email_rounded),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            hintText: 'Enter Email Address',
                          ),
                          validator: (value) => Helper.validateEmail(value),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: const Text('Password'),
                        subtitle: TextFormField(
                          controller: passwordC,
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: isPasswordVisible,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 0),
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColor.primaryColor,
                              ),
                              onPressed: () {
                                setState(
                                  () {
                                    isPasswordVisible = !isPasswordVisible;
                                  },
                                );
                              },
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            hintText: ' Enter Password',
                          ),
                          validator: (value) =>
                              Helper.validatePassword(value, passwordC.text),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                color: AppColor.blackColor,
                                decoration: TextDecoration.underline),
                          ),
                          onPressed: () {
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
                                  return ForgetPasswordPage();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: TextButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          minimumSize: const Size(150, 40),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            FocusScope.of(context).unfocus();
                            try {
                              Components.showAlertDialog(context);

                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: emailC.text.trim().toLowerCase(),
                                password: passwordC.text.trim(),
                              )
                                  .then((result) async {
                                if (result != null) {
                                  print('Main :  $selectedRole');
                                  print(FirebaseAuth.instance.currentUser);

                                  await FirebaseFirestore.instance
                                      .collection(selectedRole.toString())
                                      .doc(result.user.uid)
                                      .get()
                                      .then((value) async {
                                    print(value.data()['userType']);
                                    if (value.data()['userType'] == 'Doner' &&
                                        selectedRole == 'Doner') {
                                      await FirebaseMessaging.instance
                                          .getToken()
                                          .then((value) async {
                                        await FirebaseFirestore.instance
                                            .collection('Doner')
                                            .doc(result.user.uid)
                                            .update({
                                          'fcm_token': value
                                        }).whenComplete(() {
                                          prefs.setString('fcm_token', value);
                                        });
                                      });
                                      print('userType P :  $selectedRole');
                                      prefs.setString(
                                          "userType", value.data()['userType']);
                                      prefs.setString(
                                          "userUID",
                                          FirebaseAuth
                                              .instance.currentUser.uid);
                                      prefs.setString(
                                          'Username', value.data()['userName']);
                                      prefs.setString(
                                          'Email', value.data()['userEmail']);
                                      prefs.setString('PhoneNo',
                                          value.data()['phoneNumber']);
                                      prefs.setString('ProfilePicture',
                                          value.data()['profileImageLink']);
                                      print(FirebaseAuth.instance.currentUser);
                                      Navigator.of(context).pushAndRemoveUntil(
                                        PageRouteBuilder(
                                          transitionDuration:
                                              const Duration(seconds: 1),
                                          transitionsBuilder: (BuildContext
                                                  context,
                                              Animation<double> animation,
                                              Animation<double> secAnimation,
                                              Widget child) {
                                            animation = CurvedAnimation(
                                                parent: animation,
                                                curve: Curves.linear);
                                            return SharedAxisTransition(
                                                animation: animation,
                                                secondaryAnimation:
                                                    secAnimation,
                                                transitionType:
                                                    SharedAxisTransitionType
                                                        .horizontal,
                                                child: child);
                                          },
                                          pageBuilder: (BuildContext context,
                                              Animation<double> animation,
                                              Animation<double> secAnimation) {
                                            return FlutterZoomDrawerPage();
                                          },
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                      Components.showSnackBar(
                                          context, "Login Sucessfully");
                                    } else if (value.data()['userType'] ==
                                            'Donee' &&
                                        selectedRole == 'Donee') {
                                      await FirebaseMessaging.instance
                                          .getToken()
                                          .then((value) async {
                                        await FirebaseFirestore.instance
                                            .collection('Donee')
                                            .doc(result.user.uid)
                                            .update({
                                          'fcm_token': value
                                        }).whenComplete(() {
                                          prefs.setString('fcm_token', value);
                                        });
                                      });
                                      print('userType D :  $selectedRole');

                                      prefs.setString(
                                          "userType", value.data()['userType']);
                                      prefs.setString(
                                          "userUID",
                                          FirebaseAuth
                                              .instance.currentUser.uid);
                                      prefs.setString(
                                          'Username', value.data()['userName']);
                                      prefs.setString(
                                          'Email', value.data()['userEmail']);
                                      prefs.setString('PhoneNo',
                                          value.data()['phoneNumber']);
                                      prefs.setString('ProfilePicture',
                                          value.data()['profileImageLink']);

                                      prefs.setString(
                                          'location', value.data()['location']);

                                      print(FirebaseAuth.instance.currentUser);
                                      Navigator.of(context).pushAndRemoveUntil(
                                        PageRouteBuilder(
                                          transitionDuration:
                                              const Duration(seconds: 1),
                                          transitionsBuilder: (BuildContext
                                                  context,
                                              Animation<double> animation,
                                              Animation<double> secAnimation,
                                              Widget child) {
                                            animation = CurvedAnimation(
                                                parent: animation,
                                                curve: Curves.linear);
                                            return SharedAxisTransition(
                                                animation: animation,
                                                secondaryAnimation:
                                                    secAnimation,
                                                transitionType:
                                                    SharedAxisTransitionType
                                                        .horizontal,
                                                child: child);
                                          },
                                          pageBuilder: (BuildContext context,
                                              Animation<double> animation,
                                              Animation<double> secAnimation) {
                                            return FlutterZoomDrawerPage();
                                          },
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                      Components.showSnackBar(
                                          context, "Login Sucessfully");
                                    } else {
                                      Navigator.of(context).pop();
                                      Components.showSnackBar(context,
                                          'You are not allowed to login from this panel');
                                    }
                                  }).catchError((e) async {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.of(context).pop();
                                    Components.showSnackBar(context,
                                        'You are not allowed to login from this panel');
                                  });
                                }
                              });
                            } catch (e) {
                              Navigator.pop(context);
                              print(e);
                              switch (e.toString()) {
                                case "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.":
                                  errorMessage =
                                      "User with this email doesn't exist.";
                                  break;
                                case "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.":
                                  errorMessage =
                                      "Please Enter Correct Password.";
                                  break;
                                case "[firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred.":
                                  errorMessage =
                                      "Please Check Internet Connection";
                                  break;
                                case "[firebase_auth/invalid-email] The email address is badly formatted.":
                                  errorMessage = "Please Enter Valid Email";
                                  break;
                                default:
                                  errorMessage = "An undefined Error happened.";
                                  break;
                              }
                              Components.showSnackBar(
                                  context, errorMessage.toString());
                            }
                          }
                        },
                        child: Center(
                          child: Text(
                            "LogIn",
                            style: TextStyle(color: AppColor.whiteColor),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "OR",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(seconds: 1),
                                  transitionsBuilder: (BuildContext context,
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
                                            SharedAxisTransitionType.horizontal,
                                        child: child);
                                  },
                                  pageBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secAnimation) {
                                    return choose();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: AppColor.primaryColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectRole() {
    return PopupMenuButton(
        color: AppColor.whiteColor,
        iconSize: 30,
        icon: const Icon(
          Icons.more_vert,
          color: Colors.black,
        ),
        onSelected: (value) {
          print(value);
          if (value == MenuItem.donee) {
            setState(() {
              selectedRole = "Donee";
              print(selectedRole);
            });
          } else if (value == MenuItem.doner) {
            setState(() {
              selectedRole = "Doner";

              print(selectedRole);
            });
          } else {}
        },
        itemBuilder: (context) => [
              const PopupMenuItem(
                value: MenuItem.donee,
                child: Text("Donee"),
              ),
              const PopupMenuItem(
                value: MenuItem.doner,
                child: Text("Doner"),
              )
            ]);
  }
}

enum MenuItem { donee, doner }
