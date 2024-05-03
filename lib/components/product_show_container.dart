// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/components/product_details_page.dart';
import 'package:foodfornothing/main.dart';
import 'package:foodfornothing/screens/chat/chat_room.dart';
import 'package:foodfornothing/util/chat_helper.dart';

class ProductShowContainerPage extends StatefulWidget {
  Map<String, dynamic> productData;
  ProductShowContainerPage({Key key, @required this.productData})
      : super(key: key);

  @override
  State<ProductShowContainerPage> createState() =>
      _ProductShowContainerPageState();
}

class _ProductShowContainerPageState extends State<ProductShowContainerPage> {
  var userData;

  getUserData() async {
    userData = await FirebaseFirestore.instance
        .collection(prefs.getString("userType") == 'Donee' ? "Doner" : "Donee")
        .doc(widget.productData['userUID'])
        .get();
    // print(userData['userUID']);
  }

  DateTime endDateTime;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailsSreen(
              productData: widget.productData,
              userData: null,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
            color: AppColor.pagesColor,
            borderRadius: BorderRadius.circular(10)),
        width: 150.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 120,
                child: CachedNetworkImage(
                  imageUrl: widget.productData['productImage1'].toString(),
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                    color: AppColor.primaryColor,
                  )),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 2),
                  Text(
                    widget.productData['productName'].toString(),
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          widget.productData['productDescription'].toString(),
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            if (userData != null) {
                              String roomId = ChatHelper().chatRoomId(
                                  widget.productData['userUID'],
                                  FirebaseAuth.instance.currentUser.uid);
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
                                    return ChatRoom(
                                      userMap: userData.data(),
                                      chatRoomId: roomId,
                                    );
                                  },
                                ),
                              );
                            } else {
                              getUserData();
                            }
                          },
                          child: Icon(
                            Icons.chat,
                            color: AppColor.primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
