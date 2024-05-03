import 'package:flutter/material.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/screens/DonerHome/BottomNavBarPages/orders/doner_order1.dart';

class DonerOrderStatusPage extends StatefulWidget {
  const DonerOrderStatusPage({Key key}) : super(key: key);

  @override
  State<DonerOrderStatusPage> createState() => _DonerOrderStatusPageState();
}

class _DonerOrderStatusPageState extends State<DonerOrderStatusPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Order",
            style: TextStyle(
              color: AppColor.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColor.whiteColor,
              )),
          backgroundColor: AppColor.primaryColor,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(25.0)),
                child: TabBar(
                  indicator: BoxDecoration(
                      color: Colors.green[300],
                      borderRadius: BorderRadius.circular(25.0)),
                  labelColor: AppColor.whiteColor,
                  unselectedLabelColor: AppColor.blackColor,
                  tabs: const [
                    Tab(
                      text: 'Pending',
                    ),
                    Tab(
                      text: 'Delivered',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Order1DonerPage(status: 'pending'),
                    Order1DonerPage(status: 'delivered'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
