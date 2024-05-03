import 'package:flutter/material.dart';
import 'package:foodfornothing/screens/DoneeHome/BottomNavBarPage/DoneeHome.dart';
import 'package:foodfornothing/screens/DoneeHome/BottomNavBarPage/orders/user_orders.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/screens/chat/chat_connect_users_page.dart';

class DoneeBottomNavigationBar extends StatefulWidget {
  const DoneeBottomNavigationBar({Key key}) : super(key: key);

  @override
  State<DoneeBottomNavigationBar> createState() =>
      _DoneeBottomNavigationBarState();
}

class _DoneeBottomNavigationBarState extends State<DoneeBottomNavigationBar> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const DoneeHome(),
    ChatConnectUsers(),
    const UserOrderStatusPage(),
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
            icon: Icon(Icons.sell),
            label: 'Orders',
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
