// ignore_for_file: avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:foodfornothing/components/components.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Helper {
  static String validateName(String value) {
    if (value.isEmpty) {
      return "Please Enter a Name";
    } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
      return "Name Can Only Contain Letters and Spaces";
    } else if (value.length < 3 || value.length > 30) {
      return "Name Must be Between 3 and 30 Characters Long";
    }
    return null;
  }

  static String validateEmail(String value) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{3,}$';

    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'Enter a Valid Email Address';
    } else if (!regex.hasMatch(value)) {
      return "Please Enter a Valid Email Address";
    } else {
      return null;
    }
  }

  static String validateConfirmPassword(
      String value, String passwordC, String confirmPasswordC) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please Enter Your Password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Password must contain atleast:\n1) 8 character\n2) atleast 1 lower case\n3) atleast 1 upper case\n4) atleast 1 numaric value\n5) atleast on special character';
      } else if (passwordC != confirmPasswordC) {
        return "Please Enter Same Password";
      } else {
        return null;
      }
    }
  }

  static String validatePassword(String value, String passwordC) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please Enter Your Password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Password must contain atleast:\n- 8 character\n- atleast 1 lower case\n- atleast 1 upper case\n- atleast 1 numaric value\n- atleast on special character';
      } else {
        return null;
      }
    }
  }

  static String validateCNIC(String value) {
    String patttern = "^[0-9]{5}-[0-9]{7}-[0-9]{1}";
    RegExp regExp = RegExp(patttern);
    if (value.isEmpty) {
      return 'please enter your cnic number';
    } else if (!regExp.hasMatch(value)) {
      return 'please enter valid cnic number (XXXXX-XXXXXXX-X)';
    }
    return null;
  }

  static String validatePhoneNumberPK(String value) {
    String patttern = r'^\+?[0-9]{12}$';
    RegExp regExp = RegExp(patttern);
    if (value.isEmpty) {
      return "Please Enter a Phone Number";
    } else if (!regExp.hasMatch(value)) {
      return "Please Enter a Valid Phone Number";
    }
    return null;
  }

  static Future<List> getUserCurrentLocation(BuildContext context) async {
    print('Before : markers1');
    String userCurrentLocation;

    List<double> latLongList;
    await getUserCurrentLatLong(context).then((value) async {
      print('${value.latitude.toString()} : ${value.longitude.toString()}');

      List<Placemark> placemarks =
          await placemarkFromCoordinates(value.latitude, value.longitude);
      userCurrentLocation = placemarks.reversed.last.locality;

      latLongList = [value.latitude, value.longitude];
    });

    return latLongList;
  }

  static Future<Position> getUserCurrentLatLong(BuildContext context) async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      Components.showSnackBar(context, error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }
}
