import 'package:flutter/material.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/util/orders_helper.dart';

class Order1UserPage extends StatefulWidget {
  String status;
  Order1UserPage({
    Key key,
    @required this.status,
  }) : super(key: key);

  @override
  State<Order1UserPage> createState() => _Order1UserPageState();
}

class _Order1UserPageState extends State<Order1UserPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: StreamBuilder(
        stream:
            OrdersHelper().getUserMyOrders(context, widget.status.toString()),
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
