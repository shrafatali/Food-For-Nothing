// ignore_for_file: use_build_context_synchronously, avoid_print, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/util/orders_helper.dart';
import 'package:intl/intl.dart';

class DonerReportPage extends StatefulWidget {
  @override
  State<DonerReportPage> createState() => _DonerReportPageState();
}

class _DonerReportPageState extends State<DonerReportPage> {
  DateTime todayDate = DateTime.parse(
      "${dateTime.year}-${dateTime.month < 10 ? '0${dateTime.month}' : dateTime.month}-${dateTime.day < 10 ? '0${dateTime.day}' : dateTime.day} ${dateTime.hour < 10 ? '0${dateTime.hour}' : dateTime.hour}:${dateTime.minute < 10 ? '0${dateTime.minute}' : dateTime.minute}:${dateTime.second < 10 ? '0${dateTime.second}' : dateTime.second}");

  DateTime today_1Date = DateTime.parse(
      "${dateTime.year}-${dateTime.month < 10 ? '0${dateTime.month}' : dateTime.month}-${dateTime.day < 10 ? "0${int.parse('${dateTime.day}') - 1}" : "${dateTime.day - 1}"} ${dateTime.hour < 10 ? '0${dateTime.hour}' : dateTime.hour}:${dateTime.minute < 10 ? '0${dateTime.minute}' : dateTime.minute}:${dateTime.second < 10 ? '0${dateTime.second}' : dateTime.second}");

  DateTime today_2Date = DateTime.parse(
      "${dateTime.year}-${dateTime.month < 10 ? '0${dateTime.month}' : dateTime.month}-${dateTime.day < 10 ? "0${int.parse('${dateTime.day}') - 2}" : "${dateTime.day - 2}"} ${dateTime.hour < 10 ? '0${dateTime.hour}' : dateTime.hour}:${dateTime.minute < 10 ? '0${dateTime.minute}' : dateTime.minute}:${dateTime.second < 10 ? '0${dateTime.second}' : dateTime.second}");

  DateTime today_3Date = DateTime.parse(
      "${dateTime.year}-${dateTime.month < 10 ? '0${dateTime.month}' : dateTime.month}-${dateTime.day < 10 ? "0${int.parse('${dateTime.day}') - 3}" : "${dateTime.day - 3}"} ${dateTime.hour < 10 ? '0${dateTime.hour}' : dateTime.hour}:${dateTime.minute < 10 ? '0${dateTime.minute}' : dateTime.minute}:${dateTime.second < 10 ? '0${dateTime.second}' : dateTime.second}");

  DateTime today_4Date = DateTime.parse(
      "${dateTime.year}-${dateTime.month < 10 ? '0${dateTime.month}' : dateTime.month}-${dateTime.day < 10 ? "0${int.parse('${dateTime.day}') - 4}" : "${dateTime.day - 4}"} ${dateTime.hour < 10 ? '0${dateTime.hour}' : dateTime.hour}:${dateTime.minute < 10 ? '0${dateTime.minute}' : dateTime.minute}:${dateTime.second < 10 ? '0${dateTime.second}' : dateTime.second}");

  DateTime today_5Date = DateTime.parse(
      "${dateTime.year}-${dateTime.month < 10 ? '0${dateTime.month}' : dateTime.month}-${dateTime.day < 10 ? "0${int.parse('${dateTime.day}') - 5}" : "${dateTime.day - 5}"} ${dateTime.hour < 10 ? '0${dateTime.hour}' : dateTime.hour}:${dateTime.minute < 10 ? '0${dateTime.minute}' : dateTime.minute}:${dateTime.second < 10 ? '0${dateTime.second}' : dateTime.second}");

  DateTime today_6Date = DateTime.parse(
      "${dateTime.year}-${dateTime.month < 10 ? '0${dateTime.month}' : dateTime.month}-${dateTime.day < 10 ? "0${int.parse('${dateTime.day}') - 6}" : "${dateTime.day - 6}"} ${dateTime.hour < 10 ? '0${dateTime.hour}' : dateTime.hour}:${dateTime.minute < 10 ? '0${dateTime.minute}' : dateTime.minute}:${dateTime.second < 10 ? '0${dateTime.second}' : dateTime.second}");

  @override
  void initState() {
    getGraphCollectionData();
    super.initState();
  }

  var graphData;

  getGraphCollectionData() async {
    graphData = await FirebaseFirestore.instance
        .collection('graph')
        .doc("lvHl0KufOxtoWJWa2e90")
        // FirebaseAuth.instance.currentUser.uid.toString()
        .get();
    setState(() {});
    print(graphData['graphAndReport']['monday']['day']);
  }

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
          "Report",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColor.whiteColor,
          ),
        ),
        centerTitle: true,
      ),
      body: graphData != null
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '     Day',
                          style: TextStyle(
                            color: AppColor.primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Total Sale   ',
                          style: TextStyle(
                            color: AppColor.primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    dayListWidget(
                      DateFormat('EEEE').format(todayDate).toString(),
                      graphData['graphAndReport'][DateFormat('EEEE')
                              .format(todayDate)
                              .toString()
                              .toLowerCase()]['totalOrders']
                          .toString(),
                    ),
                    dayListWidget(
                      DateFormat('EEEE').format(today_1Date).toString(),
                      graphData['graphAndReport'][DateFormat('EEEE')
                              .format(today_1Date)
                              .toString()
                              .toLowerCase()]['totalOrders']
                          .toString(),
                    ),
                    dayListWidget(
                      DateFormat('EEEE').format(today_2Date).toString(),
                      graphData['graphAndReport'][DateFormat('EEEE')
                              .format(today_2Date)
                              .toString()
                              .toLowerCase()]['totalOrders']
                          .toString(),
                    ),
                    dayListWidget(
                      DateFormat('EEEE').format(today_3Date).toString(),
                      graphData['graphAndReport'][DateFormat('EEEE')
                              .format(today_3Date)
                              .toString()
                              .toLowerCase()]['totalOrders']
                          .toString(),
                    ),
                    dayListWidget(
                      DateFormat('EEEE').format(today_4Date).toString(),
                      graphData['graphAndReport'][DateFormat('EEEE')
                              .format(today_4Date)
                              .toString()
                              .toLowerCase()]['totalOrders']
                          .toString(),
                    ),
                    dayListWidget(
                      DateFormat('EEEE').format(today_5Date).toString(),
                      graphData['graphAndReport'][DateFormat('EEEE')
                              .format(today_5Date)
                              .toString()
                              .toLowerCase()]['totalOrders']
                          .toString(),
                    ),
                    dayListWidget(
                      DateFormat('EEEE').format(today_6Date).toString(),
                      graphData['graphAndReport'][DateFormat('EEEE')
                              .format(today_6Date)
                              .toString()
                              .toLowerCase()]['totalOrders']
                          .toString(),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: AppColor.primaryColor,
                strokeWidth: 5,
              ),
            ),
    );
  }

  Widget dayListWidget(String dayName, String totalOrders) {
    print(MediaQuery.of(context).size.height / 1000);
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      height: 65,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        shadowColor: Colors.black54,
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  dayName.toString(),
                  style: TextStyle(
                    color: AppColor.blackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  totalOrders.toString(),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColor.blackColor,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
