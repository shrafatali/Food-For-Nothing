// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/components/product_show_container.dart';
import 'package:foodfornothing/main.dart';
import 'package:foodfornothing/screens/DoneeHome/pages/see_all_products_page.dart';
import 'package:foodfornothing/screens/DoneeHome/pages/search_page.dart';
import 'package:foodfornothing/util/orders_helper.dart';

class DoneeHome extends StatefulWidget {
  const DoneeHome({Key key}) : super(key: key);

  @override
  State<DoneeHome> createState() => _DoneeHomeState();
}

class _DoneeHomeState extends State<DoneeHome> {
  @override
  Widget build(BuildContext context) {
    print(todayDateAndTime.toString());
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
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
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchPage(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: AppColor.pagesColor,
                  ),
                  padding: const EdgeInsets.only(left: 10),
                  child: TextFormField(
                    readOnly: true,
                    enabled: false,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Product",
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Near You',
                    style: TextStyle(
                      fontSize: 19,
                      color: AppColor.blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SeeAllProductsPage(),
                        ),
                      );
                    },
                    child: Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 185.0,
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

                              if (data['location'] ==
                                  prefs.getString('location')) {
                                if (data['productAvailable'] == true &&
                                    data['productType'] == 'free') {
                                  DateTime endDateTime = DateTime.parse(
                                      "${data['productEndDate']} 21:00:00");

                                  currentDateTime.isAfter(endDateTime)
                                      ? changeProductTimeOver(
                                          data['productID'].toString())
                                      : null;
                                  return ProductShowContainerPage(
                                      productData: data);
                                } else if (data['productAvailable'] == true &&
                                    data['productType'] == 'paid') {
                                  return ProductShowContainerPage(
                                      productData: data);
                                } else {
                                  return const SizedBox(height: 0, width: 0);
                                }
                              } else {
                                return const SizedBox(height: 0, width: 0);
                              }
                            },
                            scrollDirection: Axis.horizontal,
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
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Others',
                    style: TextStyle(
                      fontSize: 19,
                      color: AppColor.blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 185.0,
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
                                  data['productType'] == 'free') {
                                DateTime endDateTime = DateTime.parse(
                                    "${data['productEndDate']} 21:00:00");

                                currentDateTime.isAfter(endDateTime)
                                    ? changeProductTimeOver(
                                        data['productID'].toString())
                                    : null;
                                return ProductShowContainerPage(
                                    productData: data);
                              } else if (data['productAvailable'] == true &&
                                  data['productType'] == 'paid') {
                                return ProductShowContainerPage(
                                    productData: data);
                              } else {
                                return const SizedBox(height: 0, width: 0);
                              }
                            },
                            scrollDirection: Axis.horizontal,
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
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
