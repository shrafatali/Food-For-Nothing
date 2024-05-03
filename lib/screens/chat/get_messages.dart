// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:intl/intl.dart';

class GetMessages extends StatelessWidget {
  GetMessages({@required this.chatRoomId, Key key}) : super(key: key);

  final String chatRoomId;
  User user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  getSenderView(
    BuildContext context,
    String message,
    String type,
    String messageId,
    String messageDocumentID,
    String messageTime,
  ) =>
      GestureDetector(
        child: ChatBubble(
          clipper: ChatBubbleClipper5(type: BubbleType.sendBubble),
          alignment: Alignment.topRight,
          margin: const EdgeInsets.only(top: 10),
          backGroundColor: AppColor.primaryColor,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  messageTime,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: AppColor.blackColor, fontSize: 8),
                ),
              ],
            ),
          ),
        ),
      );

  getReceiverView(
    BuildContext context,
    String message,
    String type,
    String messageTime,
  ) =>
      GestureDetector(
        child: ChatBubble(
          clipper: ChatBubbleClipper5(type: BubbleType.receiverBubble),
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.only(top: 10),
          backGroundColor: AppColor.blackColor,
          child: Container(
            constraints: BoxConstraints(
              minWidth: 0.5,
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 5),
                Text(
                  messageTime,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: AppColor.whiteColor, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('chat_room')
            .doc(chatRoomId)
            .collection('chat')
            .orderBy("createdAt")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
              color: AppColor.primaryColor,
            ));
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListView.builder(
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              primary: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                QueryDocumentSnapshot queryDocumentSnapshot =
                    snapshot.data.docs[index];
                return queryDocumentSnapshot['author']['id'] != user.uid
                    ? getReceiverView(
                        context,
                        queryDocumentSnapshot['text'],
                        queryDocumentSnapshot['type'],
                        queryDocumentSnapshot['time'] != null
                            ? '${DateFormat.jm().format(queryDocumentSnapshot['time'].toDate())} ${DateFormat.MMMd().format(queryDocumentSnapshot['time'].toDate())}'
                            : '',
                      )
                    : getSenderView(
                        context,
                        queryDocumentSnapshot['text'],
                        queryDocumentSnapshot['type'],
                        queryDocumentSnapshot['id'],
                        queryDocumentSnapshot['messageDocumentID'],
                        queryDocumentSnapshot['time'] != null
                            ? '${DateFormat.jm().format(queryDocumentSnapshot['time'].toDate())} ${DateFormat.MMMd().format(queryDocumentSnapshot['time'].toDate())}'
                            : '',
                      );
              },
            ),
          );
        },
      ),
    );
  }
}
