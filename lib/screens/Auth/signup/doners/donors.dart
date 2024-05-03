// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:foodfornothing/screens/Auth/signup/doners/DonersCreateAccountPage.dart';
import 'package:foodfornothing/components/constants.dart';

class donors extends StatefulWidget {
  const donors({Key key}) : super(key: key);

  @override
  State<donors> createState() => _donorsState();
}

class _donorsState extends State<donors> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColor.whiteColor,
          ),
        ),
        title: Text(
          'Food For Nothing',
          style: TextStyle(color: AppColor.whiteColor),
        ),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
      ),
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: AppColor.primaryColor,
                elevation: 10,
                child: SizedBox(
                  width: 150,
                  height: 100,
                  child: InkWell(
                    radius: 100,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DonerCreateAccountPage(selectedIndex: 0),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.verified_user,
                          color: Colors.white,
                          size: 40,
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Socialist",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Card(
                color: AppColor.primaryColor,
                elevation: 10,
                child: SizedBox(
                    width: 150,
                    height: 100,
                    child: InkWell(
                      radius: 100,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DonerCreateAccountPage(selectedIndex: 1),
                            ));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.home,
                            color: Colors.white,
                            size: 40,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "HouseHold",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          )
                        ],
                      ),
                    )),
              ),
              const SizedBox(
                height: 25,
              ),
              Card(
                color: AppColor.primaryColor,
                elevation: 10,
                child: SizedBox(
                  width: 150,
                  height: 100,
                  child: InkWell(
                    radius: 100,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DonerCreateAccountPage(selectedIndex: 2),
                          ));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.hotel,
                          color: Colors.white,
                          size: 40,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Hotel",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        )
                      ],
                    ),
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
