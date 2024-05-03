// ignore_for_file: avoid_print

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodfornothing/components/components.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/screens/DoneeHome/BottomNavBarPage/orders/submitted_order_details_page.dart';
import 'package:foodfornothing/screens/DoneeHome/pages/Monitor/Monitor1.dart';
import 'package:foodfornothing/screens/DonerHome/BottomNavBarPages/Home%20Pages/view_product_details.dart';
import 'package:foodfornothing/screens/DonerHome/BottomNavBarPages/Requests.dart';
import 'package:foodfornothing/screens/DonerHome/BottomNavBarPages/orders/doner_submitted_order_details.dart';
import 'package:foodfornothing/util/push_notification.dart';
import 'package:intl/intl.dart';

String roomID = 'loading';
DateTime dateTime = DateTime.now();
DateTime currentDateTime = DateTime.parse(
    "${dateTime.year}-${dateTime.month < 10 ? '0${dateTime.month}' : dateTime.month}-${dateTime.day < 10 ? '0${dateTime.day}' : dateTime.day} ${dateTime.hour < 10 ? '0${dateTime.hour}' : dateTime.hour}:${dateTime.minute < 10 ? '0${dateTime.minute}' : dateTime.minute}:${dateTime.second < 10 ? '0${dateTime.second}' : dateTime.second}");

String chatRoomId(String user1, String user2) {
  if (user1[0].toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]) {
    return "$user1----$user2";
  } else {
    return "$user2----$user1";
  }
}

Future<dynamic> abc(String orderID) async {
  try {
    await FirebaseFirestore.instance
        .collection('Order')
        .doc(orderID.toString())
        .update({
      'status1': 'past',
    });
  } catch (e) {
    print("Some Error status: past ");
  }
}

Future<dynamic> changeProductTimeOver(String productID) async {
  try {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productID.toString())
        .update({
      'productAvailable': false,
    });
  } catch (e) {
    print("Some Error status: past ");
  }
}

class OrdersHelper {
  Stream<Widget> getUserMyOrders(context, String status) async* {
    List<Widget> x = [];
    await FirebaseFirestore.instance
        .collection('Order')
        .orderBy('time', descending: true)
        .get()
        .then(
      (value) async {
        print(value.docs);
        for (var item in value.docs) {
          print(item.data()['donerUID'].toString());

          await FirebaseFirestore.instance
              .collection('Doner')
              .doc(item.data()['donerUID'])
              .get()
              .then((donerData) async {
            print(donerData['userName'].toString());

            await FirebaseFirestore.instance
                .collection('products')
                .doc(item.data()['productID'])
                .get()
                .then((productData) async {
              if (item.data()['userID'] ==
                  FirebaseAuth.instance.currentUser.uid) {
                if (item.data()['status'] == status.toString()) {
                  if (productData['productType'] == 'paid') {
                    x.add(Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(Icons.timer),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Text(
                                          "Order status (Sale)",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  item.data()['status'],
                                  style: TextStyle(
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Divider(
                              height: 1,
                              thickness: 0.7,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(Icons.timer),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Text(
                                          "Order ID",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  item.data()['orderID'],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(Icons.date_range),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Text(
                                          "Date",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  item.data()['orderDate'],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                print(item.data()['orderID']);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserSubmittedOrderDetailsPage(
                                            productData: productData.data(),
                                            orderData: item.data(),
                                            donerData: donerData.data()),
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColor.primaryColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                ),
                                child: RichText(
                                  text: const TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Text(
                                          "Order Details",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
                  } else {
                    x.add(Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(Icons.timer),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Text(
                                          "Order status (Donate)",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  item.data()['status'],
                                  style: TextStyle(
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Divider(
                              height: 1,
                              thickness: 0.7,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(Icons.timer),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Text(
                                          "Order ID",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  item.data()['orderID'],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(Icons.date_range),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Text(
                                          "Date",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  item.data()['orderDate'],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                print(item.data()['orderID']);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserSubmittedOrderDetailsPage(
                                            productData: productData.data(),
                                            orderData: item.data(),
                                            donerData: donerData.data()),
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColor.primaryColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                ),
                                child: RichText(
                                  text: const TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Text(
                                          "Order Details",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
                  }
                }
              }
            });
          });
        }
      },
    );
    yield x.isNotEmpty
        ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: x.length,
            itemBuilder: (context, index) {
              return x[index];
            },
          )
        : Center(
            child: Text(
              'No ${status == 'past' ? "Past" : "Recived"} Orders Found',
              style: TextStyle(
                color: AppColor.blackColor,
              ),
            ),
          );
  }

  Stream<Widget> getDonerMyOrdersSale(context, String status) async* {
    List<Widget> x = [];
    await FirebaseFirestore.instance
        .collection('Order')
        .orderBy('time', descending: true)
        .get()
        .then(
      (value) async {
        print(value.docs);
        for (var item in value.docs) {
          print(item.data()['userID'].toString());

          await FirebaseFirestore.instance
              .collection('Donee')
              .doc(item.data()['userID'])
              .get()
              .then((userData) async {
            print(userData['userName'].toString());

            await FirebaseFirestore.instance
                .collection('products')
                .doc(item.data()['productID'])
                .get()
                .then((productData) async {
              print(item.data()['productID'].toString());
              if (item.data()['donerUID'] ==
                  FirebaseAuth.instance.currentUser.uid) {
                if (item.data()['status'] == status.toString()) {
                  if (productData['productType'] == 'paid') {
                    x.add(Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(Icons.timer),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Text(
                                          "Order status (Sale)",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  item.data()['status'],
                                  style: TextStyle(
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Divider(
                              height: 1,
                              thickness: 0.7,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(Icons.timer),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Text(
                                          "Order ID",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  item.data()['orderID'],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(Icons.date_range),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Text(
                                          "Date",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  item.data()['orderDate'],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                print(item.data()['orderID']);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DonerOrderDetailsPage(
                                        productData: productData.data(),
                                        orderData: item.data(),
                                        userData: userData.data()),
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColor.primaryColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                ),
                                child: RichText(
                                  text: const TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Text(
                                          "Order Details",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
                  } else {
                    x.add(Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(Icons.timer),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Text(
                                          "Order status (Donate)",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  item.data()['status'],
                                  style: TextStyle(
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Divider(
                              height: 1,
                              thickness: 0.7,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(Icons.timer),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Text(
                                          "Order ID",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  item.data()['orderID'],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(Icons.date_range),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Text(
                                          "Date",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  item.data()['orderDate'],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                print(item.data()['orderID']);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DonerOrderDetailsPage(
                                        productData: productData.data(),
                                        orderData: item.data(),
                                        userData: userData.data()),
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColor.primaryColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                ),
                                child: RichText(
                                  text: const TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Text(
                                          "Order Details",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
                  }
                }
              }
            });
          });
        }
      },
    );
    yield x.isNotEmpty
        ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: x.length,
            itemBuilder: (context, index) {
              return x[index];
            },
          )
        : Center(
            child: Text(
              'No ${status == 'past' ? "Past" : "Delivered"} Orders Found',
              style: TextStyle(
                color: AppColor.blackColor,
              ),
            ),
          );
  }

  Stream<Widget> getDonerRequestAcceptOrReject(context) async* {
    List<Widget> x = [];
    await FirebaseFirestore.instance
        .collection('Order')
        .where('donerUID', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .where('status', isEqualTo: '')
        .where('accept_reject_status', isEqualTo: '')
        .get()
        .then(
      (value) async {
        print(value.docs);
        for (var item in value.docs) {
          print(item.data()['donerUID'].toString());

          await FirebaseFirestore.instance
              .collection('Donee')
              .doc(item.data()['userID'])
              .get()
              .then((userData) async {
            print(userData['userName'].toString());
            await FirebaseFirestore.instance
                .collection('products')
                .doc(item.data()['productID'])
                .get()
                .then((productsData) {
              x.add(
                Card(
                  color: AppColor.pagesColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 10,
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                    leading: CircleAvatar(
                      backgroundImage:
                          userData['profileImageLink'].toString() == '0'
                              ? const NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXlbMgzYw0M94bT-Sp1UGBBHLj60mz3wVtWQ&usqp=CAU",
                                )
                              : NetworkImage(
                                  userData['profileImageLink'].toString(),
                                ),
                      backgroundColor: AppColor.primaryColor,
                    ),
                    title: Text(
                      userData['userName'].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          item.data()['orderDate'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          productsData['productName'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    CoolAlert.show(
                                      context: context,
                                      barrierDismissible: false,
                                      type: CoolAlertType.confirm,
                                      backgroundColor: AppColor.primaryColor,
                                      text: 'Request Accept?',
                                      onConfirmBtnTap: () async {
                                        Components.showAlertDialog(context);
                                        await FirebaseFirestore.instance
                                            .collection('Order')
                                            .doc(item
                                                .data()['orderID']
                                                .toString())
                                            .update({
                                          'status': 'pending',
                                          'accept_reject_status': 'accept',
                                          'status1': 'upcoming'
                                        });

                                        var day = DateFormat('EEEE')
                                            .format(DateTime.now())
                                            .toString()
                                            .toLowerCase();

                                        await FirebaseFirestore.instance
                                            .collection('graph')
                                            .doc("lvHl0KufOxtoWJWa2e90"
                                                // item.data()['donerUID'].toString()
                                                )
                                            .get()
                                            .then((graphData) async {
                                          print(graphData['graphAndReport'][day]
                                                  ['totalOrders']
                                              .toString());

                                          await FirebaseFirestore.instance
                                              .collection('graph')
                                              .doc("lvHl0KufOxtoWJWa2e90")
                                                // item
                                                //   .data()['donerUID']
                                                //   .toString())
                                              .update({
                                            "graphAndReport.$day.totalOrders":
                                                graphData['graphAndReport'][day]
                                                        ['totalOrders'] +
                                                    1,
                                          });
                                        });

                                        PushNotification().sendPushMessage(
                                          userData.data()['fcm_token'],
                                          'Order Accept Successfully',
                                          'Accept',
                                        );
                                        Components.showSnackBar(context,
                                            "Request Accept Sucessfully");
                                        Navigator.pop(context);
                                        Navigator.pop(context);

                                        Navigator.of(context).pushReplacement(
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
                                                Animation<double>
                                                    secAnimation) {
                                              return const DonerCaseRequestsPage();
                                            },
                                          ),
                                        );
                                      },
                                      confirmBtnText: 'OK',
                                      confirmBtnTextStyle:
                                          TextStyle(color: AppColor.whiteColor),
                                      confirmBtnColor: AppColor.primaryColor,
                                      showCancelBtn: true,
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColor.primaryColor,
                                    ),
                                    child: Text(
                                      'Accept',
                                      style: TextStyle(
                                        color: AppColor.whiteColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    CoolAlert.show(
                                      context: context,
                                      barrierDismissible: false,
                                      type: CoolAlertType.warning,
                                      backgroundColor: AppColor.primaryColor,
                                      text: 'Request Reject?',
                                      onConfirmBtnTap: () async {
                                        Components.showAlertDialog(context);
                                        await FirebaseFirestore.instance
                                            .collection('Order')
                                            .doc(item
                                                .data()['orderID']
                                                .toString())
                                            .update({
                                          'status': 'cancelled',
                                          'accept_reject_status': 'reject',
                                        });
                                        PushNotification().sendPushMessage(
                                          userData.data()['fcm_token'],
                                          'Order Not Accept',
                                          'Rejected',
                                        );

                                        Components.showSnackBar(context,
                                            "Request Reject Sucessfully");

                                        Navigator.pop(context);
                                        Navigator.pop(context);

                                        Navigator.of(context).pushReplacement(
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
                                                Animation<double>
                                                    secAnimation) {
                                              return const DonerCaseRequestsPage();
                                            },
                                          ),
                                        );
                                      },
                                      confirmBtnText: 'OK',
                                      confirmBtnTextStyle:
                                          TextStyle(color: AppColor.whiteColor),
                                      confirmBtnColor: AppColor.primaryColor,
                                      showCancelBtn: true,
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColor.primaryColor,
                                    ),
                                    child: Text(
                                      'Reject',
                                      style: TextStyle(
                                        color: AppColor.whiteColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
          });
        }
      },
    );
    yield x.isNotEmpty
        ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: x.length,
            itemBuilder: (context, index) {
              return x[index];
            },
          )
        : Center(
            child: Text(
              'No Request Found',
              style: TextStyle(
                color: AppColor.blackColor,
              ),
            ),
          );
  }

  Stream<Widget> getDonerHistoryData(context, String status) async* {
    List<Widget> x = [];
    print('History');
    await FirebaseFirestore.instance
        .collection('products')
        .orderBy('time', descending: true)
        .get()
        .then(
      (value) async {
        print(value.docs);
        for (var item in value.docs) {
          print('userUID ${item.data()['userUID'].toString()}');

          DateTime endDateTime =
              DateTime.parse("${item.data()['productEndDate']} 21:00:00");

          print(endDateTime);
          status.toString() == 'upcoming' &&
                  currentDateTime.isAfter(endDateTime)
              ? changeProductTimeOver(item.data()['productID'].toString())
              : null;

          if (currentDateTime.isBefore(endDateTime) &&
              status.toString() == 'upcoming' &&
              item.data()['userUID'] == FirebaseAuth.instance.currentUser.uid) {
            x.add(
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          item.data()['productImage1'].toString(),
                        ),
                        backgroundColor: AppColor.primaryColor,
                      ),
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
                              return ViewProductDetailesPage(
                                  productData: item.data());
                            },
                          ),
                        );
                      },
                      title: Text(
                        item.data()['productName'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 5),
                          Text("Exp.Date : ${item.data()['productEndDate']}"),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (currentDateTime.isAfter(endDateTime) &&
              status.toString() == 'past' &&
              item.data()['userUID'] == FirebaseAuth.instance.currentUser.uid) {
            x.add(
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          item.data()['productImage1'].toString(),
                        ),
                        backgroundColor: AppColor.primaryColor,
                      ),
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
                              return ViewProductDetailesPage(
                                  productData: item.data());
                            },
                          ),
                        );
                      },
                      title: Text(
                        item.data()['productName'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 5),
                          Text("Exp.Date : ${item.data()['productEndDate']}"),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
    yield x.isNotEmpty
        ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: x.length,
            itemBuilder: (context, index) {
              return x[index];
            },
          )
        : Center(
            child: Text(
              'No ${status == 'past' ? "Past" : "Upcoming"} Products Found',
              style: TextStyle(
                color: AppColor.blackColor,
              ),
            ),
          );
  }

  Stream<Widget> getDoneeMonitorRequests(context) async* {
    List<Widget> x = [];
    await FirebaseFirestore.instance
        .collection('Order')
        .orderBy('time', descending: true)
        .get()
        .then(
      (value) async {
        print(value.docs);
        for (var item in value.docs) {
          print(item.data()['donerUID'].toString());

          await FirebaseFirestore.instance
              .collection('Doner')
              .doc(item.data()['donerUID'])
              .get()
              .then((donerData) async {
            print(donerData['userName'].toString());
            await FirebaseFirestore.instance
                .collection('products')
                .doc(item.data()['productID'])
                .get()
                .then((productsData) {
              if (item.data()['userID'] ==
                  FirebaseAuth.instance.currentUser.uid) {
                if (item.data()['addRating'] == false) {
                  if (item.data()['status'] == 'delivered') {
                    x.add(
                      Card(
                        color: AppColor.pagesColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 10,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 15),
                          leading: CircleAvatar(
                            backgroundImage:
                                donerData['profileImageLink'].toString() == '0'
                                    ? const NetworkImage(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXlbMgzYw0M94bT-Sp1UGBBHLj60mz3wVtWQ&usqp=CAU",
                                      )
                                    : NetworkImage(
                                        donerData['profileImageLink']
                                            .toString(),
                                      ),
                            backgroundColor: AppColor.primaryColor,
                          ),
                          title: Text(
                            donerData['userName'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                item.data()['orderDate'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                productsData['productName'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                productsData['productType'].toString() == 'paid'
                                    ? 'Paid'
                                    : 'Free',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
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
                                  return Monitor1Page(orderData: item.data());
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                }
              }
            });
          });
        }
      },
    );
    yield x.isNotEmpty
        ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: x.length,
            itemBuilder: (context, index) {
              return x[index];
            },
          )
        : Center(
            child: Text(
              'No Data Found',
              style: TextStyle(
                color: AppColor.blackColor,
              ),
            ),
          );
  }
}
