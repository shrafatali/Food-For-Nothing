// ignore_for_file: avoid_print, use_build_context_synchronously, use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodfornothing/components/components.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/util/helper.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
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
                      ListTile(
                        contentPadding: const EdgeInsets.only(top: 20),
                        title: const Text('Email'),
                        subtitle: TextFormField(
                          controller: emailC,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      const SizedBox(
                        height: 10,
                      ),
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
                                  .sendPasswordResetEmail(
                                      email: emailC.text.trim().toString())
                                  .then((result) async {
                                Navigator.pop(context);
                                Components.showSnackBar(
                                    context, 'Send Email Please Check');
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
                            "Forget",
                            style: TextStyle(color: AppColor.whiteColor),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
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
}
