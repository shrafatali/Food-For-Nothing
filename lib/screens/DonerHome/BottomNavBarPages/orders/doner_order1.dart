// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/util/orders_helper.dart';

class Order1DonerPage extends StatefulWidget {
  String status;
  Order1DonerPage({
    Key key,
    @required this.status,
  }) : super(key: key);

  @override
  State<Order1DonerPage> createState() => _Order1DonerPageState();
}

class _Order1DonerPageState extends State<Order1DonerPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: StreamBuilder(
        stream: OrdersHelper()
            .getDonerMyOrdersSale(context, widget.status.toString()),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryColor,
                  ),
                )
              : snapshot.hasData
                  ? snapshot.data
                  : Center(
                      child: Text(
                        'No Record Found',
                        style: TextStyle(
                          color: AppColor.whiteColor,
                        ),
                      ),
                    );
        },
      ),
    );
  }
}
