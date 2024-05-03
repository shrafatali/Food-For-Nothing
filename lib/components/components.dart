// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:foodfornothing/components/constants.dart';

class Components {
  static void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: AppColor.whiteColor),
      ),
      backgroundColor: AppColor.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static showAppLogo(BuildContext context) {
    return Image.asset(
      'assets/images/app_logo.png',
      height: MediaQuery.of(context).size.height * 0.3,
    );
  }

  static showPersonIcon(BuildContext context) {
    return 'assets/icons/person_image.jpeg';
  }

  static showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          color: AppColor.primaryColor,
          strokeWidth: 5,
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
