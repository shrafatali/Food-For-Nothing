import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:foodfornothing/screens/DonerHome/BottomNavBarPages/Donate.dart';
import 'package:foodfornothing/screens/DonerHome/BottomNavBarPages/DonerHome.dart';
import 'package:foodfornothing/screens/DonerHome/BottomNavBarPages/Sale.dart';
import 'package:foodfornothing/screens/DonerHome/BottomNavBarPages/graph.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/screens/chat/chat_connect_users_page.dart';

class DonerBottomNavigationBar extends StatefulWidget {
  const DonerBottomNavigationBar({Key key}) : super(key: key);

  @override
  State<DonerBottomNavigationBar> createState() =>
      _DonerBottomNavigationBarState();
}

class _DonerBottomNavigationBarState extends State<DonerBottomNavigationBar> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const DonerHome(),
    ChatConnectUsers(),
    Donate(),
    Sale(),
    const Graph(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_rounded),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesome5.hand_holding_usd,
            ),
            label: 'Donate',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesome.shopping_basket),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesome.chart_line,
            ),
            label: 'Graph',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColor.primaryColor,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
