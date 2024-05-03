// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodfornothing/screens/DonerHome/drawer_screen.dart';
import 'package:foodfornothing/components/components.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/util/helper.dart';
import 'package:foodfornothing/main.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String imagePathProfile;
  bool isPasswordVisible = true;
  final formKey = GlobalKey<FormState>();

  final TextEditingController username =
      TextEditingController(text: prefs.getString('Username'));

  final TextEditingController emailC =
      TextEditingController(text: prefs.getString('Email'));

  final TextEditingController phoneNo =
      TextEditingController(text: prefs.getString('PhoneNo'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    imagePathProfile == null
                        ? CircleAvatar(
                            backgroundColor: AppColor.primaryColor,
                            radius: 50,
                            backgroundImage:
                                prefs.getString('ProfilePicture') != '0'
                                    ? NetworkImage(
                                        prefs.getString('ProfilePicture'),
                                      )
                                    : Image.asset(
                                        Components.showPersonIcon(context),
                                        fit: BoxFit.contain,
                                      ).image,
                          )
                        : CircleAvatar(
                            backgroundColor: AppColor.primaryColor,
                            radius: 50,
                            backgroundImage: FileImage(
                              File(imagePathProfile),
                            )),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        pickImage();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit,
                            color: AppColor.primaryColor,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Edit Profile",
                            style: TextStyle(color: AppColor.primaryColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Hi there ${prefs.getString('Username')}!",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColor.blackColor),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        controller: username,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter Name';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Fullname",
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        controller: phoneNo,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter Phone Number';
                          } else if (value.length < 10) {
                            return 'Please Valid Phone Number';
                          } else {
                            return null;
                          }
                        },
                        inputFormatters: [phoneNumberFormatter],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone Number",
                          prefixIcon: Icon(Icons.call),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        controller: emailC,
                        readOnly: true,
                        enabled: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => Helper.validateEmail(value),
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          String profileLink;
                          if (formKey.currentState.validate()) {
                            Components.showAlertDialog(context);

                            if (imagePathProfile != null) {
                              profileLink =
                                  await uploadImage(File(imagePathProfile));
                            }
                            await FirebaseFirestore.instance
                                .collection(
                                    prefs.getString("userType").toString())
                                .doc(FirebaseAuth.instance.currentUser.uid)
                                .update({
                              'userName': username.text.toString().trim(),
                              'phoneNumber': phoneNo.text.toString().trim(),
                              'profileImageLink': imagePathProfile != null
                                  ? profileLink.toString()
                                  : "0",
                            });

                            print('Profile Update Sucessfully');
                            prefs.setString(
                                'Username', username.text.trim().toString());
                            prefs.setString(
                                'ProfilePicture',
                                imagePathProfile != null
                                    ? profileLink.toString()
                                    : "0");
                            prefs.setString('PhoneNo', phoneNo.text.toString());

                            Components.showSnackBar(context,
                                "Profile Data Updated Successfully 🥰");
                            Navigator.of(context).pushAndRemoveUntil(
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
                                  return FlutterZoomDrawerPage();
                                },
                              ),
                              (Route<dynamic> route) => false,
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          minimumSize: const Size(150, 40),
                        ),
                        child: const Text("Save"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future pickImage() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Center(child: Text("Where want you pick")),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                        onTap: (() {
                          pickMedia(ImageSource.camera);
                          Navigator.pop(context);
                        }),
                        child: const Icon(Icons.camera_alt)),
                    const SizedBox(height: 5),
                    const Text("Carmera")
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: (() {
                        pickMedia(ImageSource.gallery);
                        Navigator.pop(context);
                      }),
                      child: const Icon(Icons.photo),
                    ),
                    const SizedBox(height: 5),
                    const Text("Gallery")
                  ],
                ),
              ],
            ));
      },
    );
  }

  XFile file;
  void pickMedia(ImageSource source) async {
    file = await ImagePicker().pickImage(source: source);

    if (file != null) {
      setState(() {
        imagePathProfile = file.path;
      });
    }
  }

  Future uploadImage(File imagePath) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    String postId = DateTime.now().millisecondsSinceEpoch.toString();

    Reference reference = storage.ref().child("Profileimages/$postId");

    //Upload the file to firebase
    await reference.putFile(imagePath);
    String downloadsUrlImage = await reference.getDownloadURL();
    print(downloadsUrlImage);
    return downloadsUrlImage;
  }
}
