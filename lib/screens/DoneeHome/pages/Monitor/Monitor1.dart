// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodfornothing/components/components.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/screens/DoneeHome/pages/Monitor/Monitor.dart';
import 'package:image_picker/image_picker.dart';

class Monitor1Page extends StatefulWidget {
  Map<String, dynamic> orderData;
  Monitor1Page({Key key, @required this.orderData}) : super(key: key);

  @override
  State<Monitor1Page> createState() => _Monitor1PageState();
}

class _Monitor1PageState extends State<Monitor1Page> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController question1C = TextEditingController();
  final TextEditingController question2C = TextEditingController();
  final TextEditingController question3C = TextEditingController();
  TextEditingController question4C = TextEditingController();
  TextEditingController question5C = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  bool image = false;

  String imagePath1;
  String imagePath2;
  String imagePath3;
  String imagePath4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColor.whiteColor,
            )),
        elevation: 0,
        title: Text(
          "Fill Form",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColor.whiteColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text(
                    'Did you use the food for its intended purpose?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: TextFormField(
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    controller: question1C,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Field is not Empty";
                      }
                      return null;
                    },
                    maxLines: 3,
                    minLines: 1,
                    autocorrect: true,
                    autofocus: false,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "",
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text(
                    'Did you share the food with others in need?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    maxLines: 3,
                    minLines: 1,
                    controller: question2C,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Field is not Empty";
                      }
                      return null;
                    },
                    autocorrect: true,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "",
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text(
                    'Did you share any of the donated food with family members, friends, or neighbors?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: TextFormField(
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    maxLines: 3,
                    minLines: 1,
                    controller: question3C,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Field is not Empty";
                      }
                      return null;
                    },
                    autocorrect: true,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "",
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text(
                    'Were you able to use all of the donated food before it expired or went bad?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: TextFormField(
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    controller: question4C,
                    maxLines: 3,
                    minLines: 1,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Field is not Empty";
                      }
                      return null;
                    },
                    autocorrect: true,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "",
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text(
                    'How many people have you given this food?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: TextFormField(
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    controller: question5C,
                    maxLines: 3,
                    minLines: 1,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Field is not Empty";
                      }
                      return null;
                    },
                    autocorrect: true,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "",
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    imageFileList.length < 4
                        ? pickImage()
                        : Components.showSnackBar(
                            context, "You cant add more then 4 Images");
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.09,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera_alt),
                        SizedBox(
                          height: 4,
                        ),
                        Text("Add Item Images"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                imageFileList.isEmpty
                    ? const SizedBox(
                        height: 0,
                        width: 0,
                      )
                    : Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GridView.builder(
                            itemCount: imageFileList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 3, crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  Container(
                                    width: (MediaQuery.of(context).size.width *
                                        0.3),
                                    margin: const EdgeInsets.all(5),
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      color: AppColor.blackColor,
                                      width: 2,
                                    )),
                                    child: Image.file(
                                      File(imageFileList[index].path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          imageFileList.removeAt(index);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.cancel_outlined,
                                        color: AppColor.primaryColor,
                                      ))
                                ],
                              );
                            }),
                      ),
                const SizedBox(height: 30),
                ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        if (3 < imageFileList.length) {
                          Components.showAlertDialog(context);

                          imagePath1 = await uploadImage(imageFileList[0].path);
                          imagePath2 = await uploadImage(imageFileList[1].path);
                          imagePath3 = await uploadImage(imageFileList[2].path);
                          imagePath4 = await uploadImage(imageFileList[3].path);

                          await FirebaseFirestore.instance
                              .collection("Order")
                              .doc(widget.orderData['orderID'])
                              .update({
                            'addRating': true,
                            'Image1': imagePath1,
                            'Image2': imagePath2,
                            'Image3': imagePath3,
                            'Image4': imagePath4,
                            'answer1': question1C.text.toString().trim(),
                            'answer2': question2C.text.toString().trim(),
                            'answer3': question3C.text.toString().trim(),
                            'answer4': question4C.text.toString().trim(),
                            'answer5': question5C.text.toString().trim(),
                            'time': FieldValue.serverTimestamp(),
                          });

                          Components.showSnackBar(
                              context, "Submitted Sucessfully");
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DoneeMonitorPage(),
                            ),
                          );
                        } else {
                          Components.showSnackBar(
                              context, "Please Add 4 Item Images");
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      minimumSize: const Size(150, 40),
                    ),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(color: AppColor.whiteColor),
                      ),
                    )),
                const SizedBox(height: 20),
              ],
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
                          pickMedia(0);
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
                        pickMedia(1);
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

  void pickMedia(int value) async {
    if (value == 0) {
      try {
        XFile file = await ImagePicker().pickImage(source: ImageSource.camera);

        if (file != null) {
          setState(() {
            imageFileList.add(XFile(file.path));
          });
        }
      } catch (e) {
        print(e.toString());
      }
    } else if (value == 1) {
      try {
        final List<XFile> selectedImages = await imagePicker.pickMultiImage();
        if (selectedImages.isNotEmpty) {
          setState(() {
            imageFileList.addAll(selectedImages);
            image = true;
          });
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future uploadImage(String imagePath) async {
    String postId = DateTime.now().millisecondsSinceEpoch.toString();

    Reference reference = FirebaseStorage.instance
        .ref()
        .child('MonitorImages')
        .child("$postId.jpg");
    await reference.putFile(File(imagePath));
    String downloadsUrlImage = await reference.getDownloadURL();
    return downloadsUrlImage;
  }
}
