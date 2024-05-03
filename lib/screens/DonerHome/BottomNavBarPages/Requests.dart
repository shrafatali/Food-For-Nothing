import 'package:flutter/material.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/util/orders_helper.dart';

class DonerCaseRequestsPage extends StatelessWidget {
  const DonerCaseRequestsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColor.whiteColor,
            )),
        title: const Text(
          'Cases Requests',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder(
          stream: OrdersHelper().getDonerRequestAcceptOrReject(context),
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
      ),
    );
  }
}
