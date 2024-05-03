import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:foodfornothing/screens/DoneeHome/DoneeBottomNavigationBar.dart';
import 'package:foodfornothing/screens/DoneeHome/doneeMenuScreenPage.dart';
import 'package:foodfornothing/screens/DonerHome/DonerBottomNavigationBar.dart';
import 'package:foodfornothing/screens/DonerHome/donerMenuScreenPage.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/main.dart';

class FlutterZoomDrawerPage extends StatelessWidget {
  FlutterZoomDrawerPage({Key key}) : super(key: key);

  final zoomDrawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZoomDrawer(
        controller: zoomDrawerController,
        borderRadius: 24.0,
        showShadow: true,
        menuBackgroundColor: AppColor.whiteColor,
        shadowLayer2Color: AppColor.primaryColor.withOpacity(.8),
        shadowLayer1Color: AppColor.primaryColor.withOpacity(.1),
        angle: 0.0,
        drawerShadowsBackgroundColor: Colors.grey,
        slideWidth: MediaQuery.of(context).size.width * 0.75,
        menuScreenWidth: MediaQuery.of(context).size.width * 0.75,
        mainScreen: prefs.getString("userType") == 'Doner'
            ? const DonerBottomNavigationBar()
            : const DoneeBottomNavigationBar(),
        menuScreen: prefs.getString("userType") == 'Doner'
            ? const DonerMenuScreenPage()
            : const DoneeMenuScreenPage(),
        style: DrawerStyle.defaultStyle,
        moveMenuScreen: false,
      ),
    );
  }
}
