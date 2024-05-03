// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodfornothing/screens/Auth/login.dart';
import 'package:foodfornothing/components/components.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/util/helper.dart';
import 'package:image_picker/image_picker.dart';

class DonerCreateAccountPage extends StatefulWidget {
  int selectedIndex;
  DonerCreateAccountPage({Key key, @required this.selectedIndex})
      : super(key: key);

  @override
  State<DonerCreateAccountPage> createState() => _DonerCreateAccountPageState();
}

class _DonerCreateAccountPageState extends State<DonerCreateAccountPage> {
  String errorMessage;
  bool isPasswordVisible = true;

  final TextEditingController passwordC = TextEditingController();
  final TextEditingController confirmPasswordC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  File cnicFrontImage;
  File cnicBackImage;

  String cincfrontlinkC;
  String cincbacksidelinkC;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColor.whiteColor,
          ),
        ),
        title: Text(
          widget.selectedIndex == 0
              ? 'Socialist Registration'
              : widget.selectedIndex == 1
                  ? 'House Hold Registration'
                  : widget.selectedIndex == 2
                      ? 'Hotel Registration'
                      : '',
          style: TextStyle(color: AppColor.whiteColor),
        ),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: const Text('Name'),
                    subtitle: TextFormField(
                      controller: nameC,
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        hintText: 'Enter username',
                      ),
                      validator: (value) => Helper.validateName(value),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: const Text('Email'),
                    subtitle: TextFormField(
                      controller: emailC,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.attach_email_rounded),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        hintText: 'Enter Email Address',
                      ),
                      validator: (value) => Helper.validateEmail(value),
                    ),
                  ),
                  const SizedBox(height: 3),
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: const Text('Phone No'),
                    subtitle: TextFormField(
                      controller: phoneC,
                      inputFormatters: [phoneNumberFormatter],
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        hintText: 'Enter Phone no',
                      ),
                      validator: (value) => Helper.validatePhoneNumberPK(value),
                    ),
                  ),
                  const SizedBox(height: 5),
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: const Text('Password'),
                    subtitle: TextFormField(
                      controller: passwordC,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: isPasswordVisible,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
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
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        hintText: 'Enter Password',
                      ),
                      validator: (value) =>
                          Helper.validatePassword(value, passwordC.text),
                    ),
                  ),
                  const SizedBox(height: 5),
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: const Text('Conf. Password'),
                    subtitle: TextFormField(
                      obscureText: isPasswordVisible,
                      controller: confirmPasswordC,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
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
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        hintText: 'Confirm password',
                      ),
                      validator: (value) => Helper.validateConfirmPassword(
                          value, passwordC.text, confirmPasswordC.text),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: InkWell(
                      onTap: () {
                        pickImage(0);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        decoration: BoxDecoration(
                          color: AppColor.pagesColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'CNIC Front Image',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: AppColor.blackColor,
                              ),
                            ),
                            cnicFrontImage == null
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 35,
                                      color:
                                          AppColor.blackColor.withOpacity(0.5),
                                    ),
                                  )
                                : Container(
                                    height: 150,
                                    width: double.infinity,
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColor.pagesColor,
                                      image: DecorationImage(
                                        image: FileImage(cnicFrontImage),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: InkWell(
                      onTap: () {
                        pickImage(1);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        decoration: BoxDecoration(
                          color: AppColor.pagesColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'CNIC Back Image',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: AppColor.blackColor,
                              ),
                            ),
                            cnicBackImage == null
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 35,
                                      color:
                                          AppColor.blackColor.withOpacity(0.5),
                                    ),
                                  )
                                : Container(
                                    height: 150,
                                    width: double.infinity,
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColor.pagesColor,
                                      image: DecorationImage(
                                        image: Image.file(cnicBackImage).image,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        if (cnicFrontImage != null && cnicBackImage != null) {
                          Components.showAlertDialog(context);
                          cincfrontlinkC =
                              await uploadImage(cnicFrontImage.path.toString());
                          cincbacksidelinkC =
                              await uploadImage(cnicBackImage.path.toString());

                          try {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: emailC.text.trim().toLowerCase(),
                                    password: passwordC.text);

                            await FirebaseFirestore.instance
                                .collection("Doner")
                                .doc(FirebaseAuth.instance.currentUser.uid
                                    .toString())
                                .set({
                              'userType': 'Doner',
                              'donerType': widget.selectedIndex == 0
                                  ? 'Socialist'
                                  : widget.selectedIndex == 1
                                      ? 'HouseHold'
                                      : widget.selectedIndex == 2
                                          ? 'Hotel'
                                          : '',
                              'userUID': FirebaseAuth.instance.currentUser.uid,
                              'userName': nameC.text.toString().trim(),
                              'userEmail': emailC.text.toString().trim(),
                              'userPassword': passwordC.text.toString().trim(),
                              'userConfirmPassword':
                                  confirmPasswordC.text.toString().trim(),
                              'phoneNumber': phoneC.text.toString().trim(),
                              'CNIC_Front': cincfrontlinkC.toString(),
                              'CNIC_Back': cincbacksidelinkC.toString(),
                              'profileImageLink': "0",
                              'productsIDs': [],
                              'fcm_token': '',
                              'ordersIDs': [],
                            }).whenComplete(() {
                              Components.showSnackBar(
                                  context, "Account Created Sucessfully");
                            });
                            // .then((value) async {
                            //   await FirebaseFirestore.instance
                            //       .collection("graph")
                            //       .doc(FirebaseAuth.instance.currentUser.uid
                            //           .toString())
                            //       .set({
                            //     "graphAndReport": {
                            //       "monday": {
                            //         "day": "monday",
                            //         "totalOrders": 0,
                            //       },
                            //       "tuesday": {
                            //         "day": "tuesday",
                            //         "totalOrders": 0,
                            //       },
                            //       "wednesday": {
                            //         "day": "wednesday",
                            //         "totalOrders": 0,
                            //       },
                            //       "thursday": {
                            //         "day": "thursday",
                            //         "totalOrders": 0,
                            //       },
                            //       "friday": {
                            //         "day": "friday",
                            //         "totalOrders": 0,
                            //       },
                            //       "saturday": {
                            //         "day": "saturday",
                            //         "totalOrders": 0,
                            //       },
                            //       "sunday": {
                            //         "day": "sunday",
                            //         "totalOrders": 0,
                            //       }
                            //     },
                            //   });
                            // Components.showSnackBar(
                            //     context, "Account Created Sucessfully");
                            // });
                            Navigator.pop(context);

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
                                  return loginPage();
                                },
                              ),
                              (Route<dynamic> route) => false,
                            );
                          } catch (e) {
                            Navigator.pop(context);
                            print(e);

                            switch (e.toString()) {
                              case "[firebase_auth/email-already-in-use] The email address is already in use by another account.":
                                errorMessage =
                                    "The email address is already in use by another account";
                                break;
                              case "[firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred.":
                                errorMessage =
                                    "Please Check Internet Connection";
                                break;
                              case "[firebase_auth/invalid-email] The email address is badly formatted.":
                                "Please Enter Valid Email";
                                break;
                              default:
                                errorMessage =
                                    "Sign Up failed, Please try again.";
                                break;
                            }
                            Components.showSnackBar(
                                context, errorMessage.toString());
                          }
                        } else {
                          Components.showSnackBar(
                              context, "Please Select CNIC Both Images");
                        }
                      } else {
                        Components.showSnackBar(
                            context, "Please Fill Form Correctly");
                      }
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: AppColor.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future pickImage(int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Center(child: Text("Where want you pick")),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    pickMedia(ImageSource.camera, index);
                    Navigator.pop(context);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.camera_alt),
                      SizedBox(height: 5),
                      Text("Carmera")
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (() {
                    pickMedia(ImageSource.gallery, index);
                    Navigator.pop(context);
                  }),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.photo),
                      SizedBox(height: 5),
                      Text("Gallery")
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }

  Future pickMedia(ImageSource imageSource, int value) async {
    XFile result = await ImagePicker().pickImage(source: imageSource);

    if (result != null) {
      if (value == 0) {
        cnicFrontImage = File(result.path);
        print(cnicFrontImage);
      } else if (value == 1) {
        cnicBackImage = File(result.path);
        print(cnicBackImage);
      }
      setState(() {});
    }
  }

  Future uploadImage(String imagePath) async {
    String postId = DateTime.now().millisecondsSinceEpoch.toString();

    Reference reference = FirebaseStorage.instance
        .ref()
        .child('DonorsCNIC_Images')
        .child("$postId.jpg");
    await reference.putFile(File(imagePath));
    String downloadsUrlImage = await reference.getDownloadURL();

    return downloadsUrlImage;
  }
}
