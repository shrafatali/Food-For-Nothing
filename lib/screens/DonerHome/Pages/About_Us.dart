// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:foodfornothing/components/constants.dart';

class AboutUsPage extends StatefulWidget {
  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
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
          "About US",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColor.whiteColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            children: const [
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  '          Food for Nothing is a mobile application that aims to address the issue of food waste while helping those in need. Our app allows donors to easily donate and sell extra food, while allowing donees to receive that donation and also buy that food at a discounted rate.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 5),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  '          Our mission is to reduce food waste and fight hunger by connecting those who have excess food with those who are in need of it. By providing an easy-to-use platform for food donations and purchases, we aim to create a more sustainable and equitable food system.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 5),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  "          We believe that every food donation can make a significant impact on someone's life. That's why we track and monitor all food donations made through our app to ensure that the food is being used for good purposes.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 5),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  '          Our app also provides users with valuable insights through graphs and reports on how much food has been donated, to whom it has been supplied, and how it has been used. This information helps us and our users understand the impact of their donations and make data-driven decisions on how to improve their food waste reduction efforts.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 5),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  '          At Food for Nothing, we are committed to making a positive impact on the world and we invite you to join us in our mission to fight food waste and hunger.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
