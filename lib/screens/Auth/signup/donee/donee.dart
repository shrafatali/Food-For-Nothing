// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:foodfornothing/screens/Auth/signup/donee/doneeCreateAccountPage.dart';
import 'package:foodfornothing/components/constants.dart';

class donee extends StatefulWidget {
  const donee({Key key}) : super(key: key);

  @override
  State<donee> createState() => _doneeState();
}

class _doneeState extends State<donee> {
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
                                doneeCreateAccountPage(selectedIndex: 0),
                          ));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.verified_user_outlined,
                          color: Colors.white,
                          size: 40,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Social Worker",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
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
                                doneeCreateAccountPage(selectedIndex: 1),
                          ));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Organization",
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
