import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/screens/DoneeHome/BottomNavBarPage/orders/order1.dart';

class UserOrderStatusPage extends StatefulWidget {
  const UserOrderStatusPage({Key key}) : super(key: key);

  @override
  State<UserOrderStatusPage> createState() => _UserOrderStatusPageState();
}

class _UserOrderStatusPageState extends State<UserOrderStatusPage> {
  String userID = FirebaseAuth.instance.currentUser.uid;

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
          leading: const SizedBox(height: 0, width: 0),
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
                      text: 'Received',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Order1UserPage(status: 'pending'),
                    Order1UserPage(status: 'delivered'),
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
