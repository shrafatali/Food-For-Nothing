// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/util/orders_helper.dart';

class DonerHistory1Page extends StatefulWidget {
  String status;
  DonerHistory1Page({
    Key key,
    @required this.status,
  }) : super(key: key);

  @override
  State<DonerHistory1Page> createState() => _DonerHistory1PageState();
}

class _DonerHistory1PageState extends State<DonerHistory1Page> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: StreamBuilder(
        stream: OrdersHelper()
            .getDonerHistoryData(context, widget.status.toString()),
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
                          color: AppColor.blackColor,
                        ),
                      ),
                    );
        },
      ),
    );
  }
}
