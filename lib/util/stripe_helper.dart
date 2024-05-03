// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/main.dart';
import 'package:foodfornothing/screens/DonerHome/drawer_screen.dart';
import 'package:foodfornothing/util/push_notification.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PaymentController extends GetxController {
  Map<String, dynamic> paymentIntentData;

  Future makePayment({
    BuildContext context,
    @required Map<String, dynamic> productData,
    @required String quantity,
    // @required String totalPrice,
    @required String amount,
    @required String currency,
  }) async {
    print(productData['productID'].toString());
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          primaryButtonColor: AppColor.primaryColor,
          applePay: true,
          googlePay: true,
          testEnv: true,
          merchantCountryCode: 'US',
          merchantDisplayName: 'Prospects',
          customerId: paymentIntentData['customer'],
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          customerEphemeralKeySecret: paymentIntentData['ephemeralKey'],
        ));
        // displayPaymentSheet(amount.toString());
        displayPaymentSheet(context, amount, productData, quantity);
      }
      return true;
    } catch (e, s) {
      if (kDebugMode) {
        print('exception:$e$s');
      }
      return false;
    }
  }

  displayPaymentSheet(
    BuildContext context1,
    String amount,
    Map<String, dynamic> productData,
    String quantity,
  ) async {
    try {
      await Stripe.instance.presentPaymentSheet();

      try {
        DateTime date = DateTime(DateTime.now().year);
        String orderID = DateTime.now().millisecondsSinceEpoch.toString();

        await FirebaseFirestore.instance.collection("Order").doc(orderID).set({
          'productID': productData['productID'],
          "quantity": quantity.toString(),
          "totalPrice": amount.toString(),
          'userID': FirebaseAuth.instance.currentUser.uid,
          "donerUID": productData['userUID'],
          'addRating': false,
          "orderID": orderID,
          "donerStatus": "",
          "userSideStatus": 'pending',
          "orderDate": todayDateAndTime,
          "status": "pending",
          'time': FieldValue.serverTimestamp()
        });

        print("Order Complete");
        await FirebaseFirestore.instance
            .collection("Doner")
            .doc(productData['userUID'])
            .update({
          'ordersIDs': FieldValue.arrayUnion([orderID]),
        });

        print("Store Complete");
        // print(user.uid);

        await FirebaseFirestore.instance
            .collection("products")
            .doc(productData['productID'])
            .update({
          'totalOrderIDs': FieldValue.arrayUnion([orderID]),
          'totalItems': (int.parse(productData['totalItems']) -
                  int.parse(quantity.toString()))
              .toString(),
        });

        print("Procuct Complete");

        var day =
            DateFormat('EEEE').format(DateTime.now()).toString().toLowerCase();

        await FirebaseFirestore.instance
            .collection('graph')
            .doc(productData['userUID'].toString())
            .get()
            .then((graphData) async {
          print(graphData['graphAndReport'][day]['totalOrders'].toString());

          await FirebaseFirestore.instance
              .collection('graph')
              .doc("lvHl0KufOxtoWJWa2e90")
              //productData['userUID'].toString()
              .update({
            "graphAndReport.$day.totalOrders": graphData['graphAndReport'][day]
                    ['totalOrders'] +
                double.parse(quantity.toString()),
          });

          var userData = await FirebaseFirestore.instance
              .collection("Doner")
              .doc(productData['userUID'])
              .get();
          PushNotification().sendPushMessage(
            userData.data()['fcm_token'],
            '${prefs.getString('Username')} Send Order Request',
            'Order Request (Sale)',
          );
        });
      } catch (e) {
        print(e.toString());
        print('Error');
      }

      Get.snackbar(
        'Payment Successful ',
        'and Order Submitted Sucessfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.primaryColor,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 2),
      );
      Get.offAll(FlutterZoomDrawerPage());

      return null;
    } on Exception catch (e) {
      if (e is StripeException) {
        if (kDebugMode) {
          print("Error from Stripe: ${e.error.localizedMessage}");
        }
      } else {
        if (kDebugMode) {
          print("Unforeseen error: ${e.toString()}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("exception:$e");
      }
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51MxZqvE8lNghN5wBn8v9L3YJDChLw1tpKACGqd1pdBsgA6D7vmJr7HkdTDmvDo7tN6IxM55qzf8P4Hee93ZoRbm400Q34kd1p8',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      if (kDebugMode) {
        print('err charging user: ${err.toString()}');
      }
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}
