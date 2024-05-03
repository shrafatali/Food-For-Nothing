// ignore_for_file: avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/main.dart';
import 'package:foodfornothing/screens/DonerHome/BottomNavBarPages/Home%20Pages/updateDonateProduct.dart';
import 'package:foodfornothing/screens/DonerHome/BottomNavBarPages/Home%20Pages/view_product_details.dart';
import 'package:foodfornothing/screens/DonerHome/BottomNavBarPages/Home%20Pages/updateSaleProduct.dart';
import 'package:foodfornothing/util/orders_helper.dart';

class DonerHome extends StatefulWidget {
  const DonerHome({Key key}) : super(key: key);

  @override
  State<DonerHome> createState() => _DonerHomeState();
}

class _DonerHomeState extends State<DonerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        leading: IconButton(
          onPressed: () {
            ZoomDrawer.of(context).open();
          },
          icon: Icon(
            Icons.menu,
            color: AppColor.whiteColor,
          ),
        ),
        title: Text(
          'Food For Nothing',
          style: TextStyle(color: AppColor.whiteColor),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Text(
                      "Welcome ",
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColor.blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Text(
                      '${prefs.getString('Username')}!',
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 200.0,
            width: double.infinity,
            child: Carousel(
              images: const [
                AssetImage('assets/images/t11.jpg'),
                AssetImage('assets/images/s2.png'),
                AssetImage('assets/images/s3.png'),
                AssetImage('assets/images/s4.png.png'),
              ],
              dotSize: 7.0,
              dotSpacing: 15.0,
              dotColor: Colors.white,
              dotIncreasedColor: AppColor.primaryColor,
              indicatorBgPadding: 5.0,
              dotBgColor: Colors.transparent,
              borderRadius: false,
              moveIndicatorFromBottom: 180.0,
              noRadiusForIndicator: true,
              overlayShadow: true,
              overlayShadowColors: AppColor.primaryColor,
              overlayShadowSize: 0.5,
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("products")
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    if (snapshot.data.docs.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data =
                              snapshot.data.docs[index].data();
                          if (data['productAvailable'] == true &&
                              data['productType'] == 'free' &&
                              data['userUID'] ==
                                  FirebaseAuth.instance.currentUser.uid) {
                            DateTime endDateTime = DateTime.parse(
                                "${data['productEndDate']} 21:00:00");

                            currentDateTime.isAfter(endDateTime)
                                ? changeProductTimeOver(
                                    data['productID'].toString())
                                : null;
                            return donerProductList(data);
                          } else if (data['productAvailable'] == true &&
                              data['productType'] == 'paid' &&
                              data['userUID'] ==
                                  FirebaseAuth.instance.currentUser.uid) {
                            return donerProductList(data);
                          } else {
                            return const SizedBox(height: 0, width: 0);
                          }
                        },
                        scrollDirection: Axis.vertical,
                      );
                    } else {
                      return Center(
                        child: Text(
                          "No Product Is Avaliable",
                          style: TextStyle(color: AppColor.blackColor),
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primaryColor,
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  donerProductList(Map<String, dynamic> productData) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.all(5),
        horizontalTitleGap: 20,
        leading: Container(
          width: 70,
          height: 60,
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: CachedNetworkImage(
            imageUrl: productData['productImage1'],
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
                child: CircularProgressIndicator(
              color: AppColor.blackColor,
            )),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        title: Text(
          productData["productName"].toString(),
          style: const TextStyle(
              fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
          maxLines: 1,
        ),
        subtitle: Text(
          productData["productDescription"].toString(),
          maxLines: 2,
          style: const TextStyle(
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: PopupMenuButton(
            color: Colors.grey.shade200,
            iconSize: 30,
            icon: Icon(
              Icons.more_vert,
              color: AppColor.blackColor,
            ),
            onSelected: (value) {
              print(value);
              if (value == MenuItem.view) {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewProductDetailesPage(
                        productData: productData,
                      ),
                    ),
                  );
                });
              } else if (value == MenuItem.edit) {
                setState(() {
                  productData['productType'] == 'paid'
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateSaleProductPage(
                              productData: productData,
                            ),
                          ),
                        )
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateDonateProductPage(
                              productData: productData,
                            ),
                          ),
                        );
                });
              } else {}
            },
            itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: MenuItem.view,
                    child: Text("View Product"),
                  ),
                  const PopupMenuItem(
                    value: MenuItem.edit,
                    child: Text("Edit Product"),
                  ),
                ]),
      ),
    );
  }
}

enum MenuItem {
  view,
  edit,
}
