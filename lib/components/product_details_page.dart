// ignore_for_file: use_build_context_synchronously, avoid_print, non_constant_identifier_names, use_key_in_widget_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodfornothing/components/components.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/main.dart';
import 'package:foodfornothing/util/push_notification.dart';
import 'package:foodfornothing/util/stripe_helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:page_indicator/page_indicator.dart';

class ItemDetailsSreen extends StatefulWidget {
  Map<String, dynamic> productData;
  var userData;

  ItemDetailsSreen({
    @required this.productData,
    @required this.userData,
  });

  @override
  State<ItemDetailsSreen> createState() => _ItemDetailsSreenState();
}

class _ItemDetailsSreenState extends State<ItemDetailsSreen> {
  bool isChecked = false;
  DateTime date = DateTime(DateTime.now().year);
  final paymentController = Get.put(PaymentController());

  bool chk = true;
  int totalItem = 1;
  double Price_Per_Item = 0;
  double Total_Price = 0;

  double totalRating = 0.0;

  @override
  void initState() {
    calculateRating(widget.productData['userUID'].toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (chk && widget.productData['productType'] == 'paid') {
      Price_Per_Item = double.parse(widget.productData['pricePerItem']);
      Total_Price += Price_Per_Item;
      chk = false;
    }

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
        centerTitle: true,
        title: Text(
          'Item Details',
          maxLines: 2,
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.whiteColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.1,
                child: LayoutBuilder(
                  builder: (_, constraints) {
                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: PageIndicatorContainer(
                            align: IndicatorAlign.bottom,
                            length: 4,
                            indicatorSpace: 10.0,
                            padding: const EdgeInsets.all(10),
                            indicatorColor: AppColor.whiteColor,
                            indicatorSelectorColor: AppColor.primaryColor,
                            shape: IndicatorShape.circle(size: 12),
                            child: PageView(
                                physics: const BouncingScrollPhysics(),
                                children: <Widget>[
                                  HeaderImages(
                                      widget.productData['productImage1']),
                                  HeaderImages(
                                      widget.productData['productImage2']),
                                  HeaderImages(
                                      widget.productData['productImage3']),
                                  HeaderImages(
                                      widget.productData['productImage4']),
                                ]),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 9,
                          child: Text(
                            widget.productData['productName'].toString(),
                            maxLines: 3,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Price : ${widget.productData['productType'].toString() == 'paid' ? widget.productData['pricePerItem'].toString() : 'Free'}',
                      maxLines: 1,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (totalItem > 1 &&
                                int.parse(widget.productData['totalItems']) >
                                    0) {
                              setState(() {
                                totalItem--;
                                Total_Price = Total_Price - Price_Per_Item;
                                print(Total_Price);
                              });
                            }
                          },
                          child: Icon(
                            Icons.horizontal_rule,
                            color: AppColor.blackColor.withOpacity(0.7),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.blackColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$totalItem',
                            style: TextStyle(
                              color: AppColor.blackColor,
                            ),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              if (int.parse(widget.productData['totalItems']) >
                                  totalItem) {
                                setState(() {
                                  Total_Price = Total_Price + Price_Per_Item;
                                  totalItem++;
                                  print(Total_Price);
                                });
                              }
                            },
                            child: Icon(Icons.add, color: AppColor.blackColor)),
                        const Spacer(),
                        widget.productData['productType'] == 'paid'
                            ? Text(
                                'Total : $Total_Price',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColor.blackColor,
                                ),
                              )
                            : Text(
                                '',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColor.blackColor,
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Divider(
                color: AppColor.blackColor,
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text(
                  "Product Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description : ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.productData['productDescription'].toString(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Available Items : ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.productData['totalItems'].toString(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location : ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.productData['location'].toString(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Donation Rating : ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: RatingBar.builder(
                        initialRating: totalRating,
                        minRating: totalRating,
                        itemSize: 20.0,
                        maxRating: 5,
                        ignoreGestures: true,
                        direction: Axis.horizontal,
                        // allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    ),
                    // Text(
                    //   totalRating.toString(),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: Text(widget.productData['productType'] == 'paid'
                    ? "Buy All Available Items"
                    : "Request For All Items"),
                value: isChecked,
                onChanged: (newValue) {
                  setState(() {
                    isChecked = newValue;

                    if (isChecked == true) {
                      setState(() {
                        Total_Price = Total_Price *
                            int.parse(widget.productData['totalItems']);
                        totalItem = int.parse(widget.productData['totalItems']);
                      });
                    } else {
                      setState(() {
                        Total_Price = widget.productData['productType'] ==
                                'paid'
                            ? double.parse(
                                widget.productData['pricePerItem'].toString())
                            : 0;
                        totalItem = 1;
                      });
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ElevatedButton(
                    onPressed: int.parse(widget.productData['totalItems']) > 0
                        ? () async {
                            int price =
                                int.tryParse(Total_Price.toInt().toString());
                            print(price.toString());
                            if (widget.productData['productType'] == 'paid') {
                              await paymentController
                                  .makePayment(
                                productData: widget.productData,
                                quantity: totalItem.toString(),
                                amount: price.toString(),
                                currency: 'PKR',
                              )
                                  .then((value) {
                                print('Payment');
                              });
                            } else {
                              int.parse(widget.productData['totalItems']) > 0
                                  ? CoolAlert.show(
                                      context: context,
                                      backgroundColor: AppColor.primaryColor,
                                      confirmBtnColor: AppColor.primaryColor,
                                      barrierDismissible: false,
                                      type: CoolAlertType.confirm,
                                      text: 'Order?',
                                      onConfirmBtnTap: () async {
                                        Components.showAlertDialog(context);
                                        String orderID = DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString();
                                        await FirebaseFirestore.instance
                                            .collection('Order')
                                            .doc(orderID.toString())
                                            .set(
                                          {
                                            "status": "",
                                            'status1': '',
                                            'addRating': false,
                                            'accept_reject_status': '',
                                            'orderID': orderID.toString(),
                                            'productID':
                                                widget.productData['productID'],
                                            'userID': FirebaseAuth
                                                .instance.currentUser.uid,
                                            "donerUID":
                                                widget.productData['userUID'],
                                            "orderDate": todayDateAndTime,
                                            'time':
                                                FieldValue.serverTimestamp(),
                                          },
                                        ).then((value) async {
                                          await FirebaseFirestore.instance
                                              .collection("products")
                                              .doc(widget
                                                  .productData['productID'])
                                              .update({
                                            'totalItems': (int.parse(
                                                        widget.productData[
                                                            'totalItems']) -
                                                    int.parse(
                                                        totalItem.toString()))
                                                .toString(),
                                          });
                                        }).whenComplete(() async {
                                          await FirebaseFirestore.instance
                                              .collection("Doner")
                                              .doc(
                                                  widget.productData['userUID'])
                                              .get()
                                              .then((userData) {
                                            PushNotification().sendPushMessage(
                                              userData.data()['fcm_token'],
                                              '${prefs.getString('Username')} Send Order Request',
                                              'Order Request (Donate)',
                                            );
                                            Navigator.pop(context);
                                            Navigator.pop(context);

                                            Components.showSnackBar(context,
                                                'Order Request Send Successfully');
                                            Navigator.pop(context);
                                          });
                                        });
                                      },
                                      confirmBtnText: 'Yes',
                                      showCancelBtn: true,
                                    )
                                  : null;
                            }
                          }
                        : () {
                            //
                          },
                    style: TextButton.styleFrom(
                      backgroundColor:
                          int.parse(widget.productData['totalItems']) > 0
                              ? AppColor.primaryColor
                              : Colors.red,
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    child: widget.productData['productType'] == 'paid'
                        ? int.parse(widget.productData['totalItems']) > 0
                            ? Text(
                                'Pay and Order ',
                                style: TextStyle(color: AppColor.whiteColor),
                              )
                            : const Text('Product Is Not Available')
                        : int.parse(widget.productData['totalItems']) > 0
                            ? Text(
                                'Order',
                                style: TextStyle(color: AppColor.whiteColor),
                              )
                            : const Text('Product Is Not Available')),
              ),
              const SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }

  HeaderImages(String imageLink) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: CachedNetworkImage(
        imageUrl: imageLink,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
            child: CircularProgressIndicator(
          color: AppColor.whiteColor,
        )),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  calculateRating(String uid) async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('products')
        .where('productType', isEqualTo: 'free')
        .where('userUID', isEqualTo: uid.toString())
        .get();

    double rating = 0;

    DateTime dateTime = DateTime.now();
    String date =
        '${dateTime.year}-${dateTime.month < 10 ? '0${dateTime.month}' : dateTime.month}';

    for (var document in snap.docs) {
      Timestamp timestamp = document['time'];
      DateTime dateTime = timestamp.toDate();
      String dateSubstring = DateFormat('yyyy-MM').format(dateTime);

      if (dateSubstring.toString() == date) {
        rating = rating + 1;
      }
    }
    setState(() {
      totalRating = rating;
      print(totalRating.toString());
    });
  }
}
