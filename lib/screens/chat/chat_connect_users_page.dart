// ignore_for_file: use_key_in_widget_constructors

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/main.dart';
import 'package:foodfornothing/screens/chat/chat_room.dart';
import 'package:intl/intl.dart';

class ChatConnectUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        leading: const SizedBox(height: 0, width: 0),
        title: Text(
          'Messages',
          style: TextStyle(
            fontSize: 18,
            color: AppColor.whiteColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: StreamBuilder(
            stream: getChat(context),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primaryColor,
                      ),
                    )
                  : snapshot.hasData
                      ? snapshot.data
                      : Center(
                          child: Text(
                            'No Chat Found',
                            style: TextStyle(
                              color: AppColor.blackColor,
                            ),
                          ),
                        );
            },
          ),
        ),
      ),
    );
  }

  Stream<Widget> getChat(context) async* {
    List x = <Widget>[];
    List users = [];
    await FirebaseFirestore.instance
        .collection('chat_room')
        .orderBy('time', descending: true)
        .get()
        .then((value) async {
      for (var item in value.docs) {
        print(item.data()['time']);
        print(item.id);
        if (item.id
            .split(',')
            .contains(FirebaseAuth.instance.currentUser.uid)) {
          users = item.id.split(',');
          users.remove(FirebaseAuth.instance.currentUser.uid);

          await FirebaseFirestore.instance
              .collection(
                  prefs.getString("userType") == 'Donee' ? 'Doner' : 'Donee')
              .doc(users.join(',').toString())
              .get()
              .then((userData) {
            x.add(
              Card(
                child: ListTile(
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
                          return ChatRoom(
                            userMap: userData.data(),
                            chatRoomId: item.id,
                          );
                        },
                      ),
                    );
                  },
                  leading: userData.data()['profileImageLink'] == '0'
                      ? CircleAvatar(
                          backgroundColor: AppColor.primaryColor,
                          child: Text(
                            userData.data()['userName'][0],
                            style: TextStyle(
                              color: AppColor.whiteColor,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor: AppColor.primaryColor,
                          backgroundImage: NetworkImage(
                              userData.data()['profileImageLink'].toString()),
                        ),
                  title: Text(
                    userData.data()['userName'].toString(),
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColor.blackColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  subtitle: Text(
                    item.data()['lastMessage'].toString(),
                    maxLines: 1,
                    style: TextStyle(
                      color: AppColor.blackColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  trailing: Text(
                    '${DateFormat.jm().format(item.data()['time'].toDate())}\n${DateFormat.MMMd().format(item.data()['time'].toDate())}',
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            );
          });
        }
      }
    });

    yield x.isNotEmpty
        ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: x.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return x[index];
            },
          )
        : Center(
            child: Text(
              'No Chat Found',
              style: TextStyle(
                color: AppColor.blackColor,
              ),
            ),
          );
  }
}
