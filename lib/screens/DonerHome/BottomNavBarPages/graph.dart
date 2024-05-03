// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/util/orders_helper.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesData {
  final String day;
  final double sales;
  SalesData(this.day, this.sales);
}

class Graph extends StatefulWidget {
  const Graph({Key key}) : super(key: key);

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
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
    print(DateTime.now().toString());
    return graphData != null
        ? Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              leading: const SizedBox(height: 0, width: 0),
              title: Text(
                'Graph',
                style: TextStyle(color: AppColor.whiteColor),
              ),
              centerTitle: true,
              backgroundColor: AppColor.primaryColor,
            ),
            body: Center(
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <LineSeries<SalesData, String>>[
                  LineSeries<SalesData, String>(
                      dataSource: <SalesData>[
                        SalesData(
                          DateFormat('EEEE')
                              .format(today_6Date)
                              .toString()
                              .toLowerCase()
                              .substring(0, 3),
                          double.parse(
                            graphData['graphAndReport'][DateFormat('EEEE')
                                    .format(today_6Date)
                                    .toString()
                                    .toLowerCase()]['totalOrders']
                                .toString(),
                          ),
                        ),
                        SalesData(
                          DateFormat('EEEE')
                              .format(today_5Date)
                              .toString()
                              .toLowerCase()
                              .substring(0, 3),
                          double.parse(
                            graphData['graphAndReport'][DateFormat('EEEE')
                                    .format(today_5Date)
                                    .toString()
                                    .toLowerCase()]['totalOrders']
                                .toString(),
                          ),
                        ),
                        SalesData(
                          DateFormat('EEEE')
                              .format(today_4Date)
                              .toString()
                              .toLowerCase()
                              .substring(0, 3),
                          double.parse(
                            graphData['graphAndReport'][DateFormat('EEEE')
                                    .format(today_4Date)
                                    .toString()
                                    .toLowerCase()]['totalOrders']
                                .toString(),
                          ),
                        ),
                        SalesData(
                          DateFormat('EEEE')
                              .format(today_3Date)
                              .toString()
                              .toLowerCase()
                              .substring(0, 3),
                          double.parse(
                            graphData['graphAndReport'][DateFormat('EEEE')
                                    .format(today_3Date)
                                    .toString()
                                    .toLowerCase()]['totalOrders']
                                .toString(),
                          ),
                        ),
                        SalesData(
                          DateFormat('EEEE')
                              .format(today_2Date)
                              .toString()
                              .toLowerCase()
                              .substring(0, 3),
                          double.parse(
                            graphData['graphAndReport'][DateFormat('EEEE')
                                    .format(today_2Date)
                                    .toString()
                                    .toLowerCase()]['totalOrders']
                                .toString(),
                          ),
                        ),
                        SalesData(
                          DateFormat('EEEE')
                              .format(today_1Date)
                              .toString()
                              .toLowerCase()
                              .substring(0, 3),
                          double.parse(
                            graphData['graphAndReport'][DateFormat('EEEE')
                                    .format(today_1Date)
                                    .toString()
                                    .toLowerCase()]['totalOrders']
                                .toString(),
                          ),
                        ),
                        SalesData(
                          DateFormat('EEEE')
                              .format(todayDate)
                              .toString()
                              .toLowerCase()
                              .substring(0, 3),
                          double.parse(
                            graphData['graphAndReport'][DateFormat('EEEE')
                                    .format(todayDate)
                                    .toString()
                                    .toLowerCase()]['totalOrders']
                                .toString(),
                          ),
                        ),
                      ],
                      xValueMapper: (SalesData sales, _) => sales.day,
                      yValueMapper: (SalesData sales, _) => sales.sales)
                ],
              ),
            ),
          )
        : Center(
            child: CircularProgressIndicator(
              color: AppColor.primaryColor,
              strokeWidth: 5,
            ),
          );
  }
}
