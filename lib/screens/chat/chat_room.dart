// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/main.dart';
import 'package:foodfornothing/screens/chat/get_messages.dart';
import 'package:foodfornothing/util/push_notification.dart';
import 'package:uuid/uuid.dart';

class ChatRoom extends StatefulWidget {
  final Map<String, dynamic> userMap;
  final String chatRoomId;

  const ChatRoom({
    Key key,
    @required this.userMap,
    @required this.chatRoomId,
  }) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _message = TextEditingController();

  String messageBody;

  void _handleSendPressed(String message, String type) async {
    await FirebaseFirestore.instance
        .collection('chat_room')
        .doc(widget.chatRoomId)
        .set({
      'lastMessage': message.toString(),
      'room_id': widget.chatRoomId,
      'time': FieldValue.serverTimestamp(),
    });

    String messageDocumentID = DateTime.now().millisecondsSinceEpoch.toString();
    await FirebaseFirestore.instance
        .collection('chat_room')
        .doc(widget.chatRoomId)
        .collection('chat')
        .doc(messageDocumentID.toString())
        .set({
      "author": {
        "firstName": prefs.getString('Username'),
        "id": FirebaseAuth.instance.currentUser.uid,
      },
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "id": const Uuid().v4(),
      "text": message,
      "type": type,
      'time': FieldValue.serverTimestamp(),
      'messageDocumentID': messageDocumentID.toString(),
    }).whenComplete(() {
      print(widget.userMap['fcm_token'].toString());
      PushNotification().sendPushMessage(
        widget.userMap['fcm_token'].toString(),
        'Message : ${message.toString()}',
        prefs.getString('Username').toString(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                  color: AppColor.blackColor,
                ),
                const SizedBox(
                  width: 5,
                ),
                widget.userMap['profileImageLink'] != '0'
                    ? CircleAvatar(
                        backgroundColor: AppColor.primaryColor,
                        backgroundImage: NetworkImage(
                            widget.userMap['profileImageLink'].toString()),
                      )
                    : CircleAvatar(
                        backgroundColor: AppColor.primaryColor,
                        child: Text(
                          widget.userMap['userName'][0],
                          style: TextStyle(
                            color: AppColor.whiteColor,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
        title: Text(
          widget.userMap['userName'].toString(),
          style: TextStyle(
            fontSize: 18,
            color: AppColor.blackColor,
          ),
        ),
      ),
      backgroundColor: AppColor.pagesColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: GetMessages(chatRoomId: widget.chatRoomId),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      spreadRadius: 0.5,
                      blurRadius: 0.5,
                      offset: const Offset(0, 0),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: TextField(
                        controller: _message,
                        keyboardType: TextInputType.text,
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Type your message',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_message.text.isNotEmpty) {
                          _handleSendPressed(_message.text, 'text');
                          _message.clear();
                        }
                      },
                      icon: Icon(
                        Icons.send,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
