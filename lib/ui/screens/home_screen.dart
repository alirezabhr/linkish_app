import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/suggested_ad_screen.dart';
import '../screens/approved_ad_screen.dart';
import '../screens/wallet_screen.dart';
import '../screens/profile_screen.dart';
import '../../services/logger_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    SuggestedAdScreen(),
    ApprovedAdScreen(),
    WalletScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("لینکیش"),
        actions: [
          IconButton(
            onPressed: () async {
              LoggerService logger = LoggerService();
              await logger.setUserData();
              await logger.sendLog(
                'notification_btn',
                {
                  "message": 'pressed on btn',
                },
              );
            },
            icon: Icon(Icons.notifications_sharp),
          ),
        ],
      ),
      // drawer: Drawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded, color: Colors.orange),
            label: 'خانه',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline, color: Colors.orange),
            label: 'کمپین ها',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined,
                color: Colors.orange),
            label: 'کیف پول',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: Colors.orange),
            label: 'پروفایل',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange[700],
        onTap: _onItemTapped,
      ),
      body: _widgetOptions[_selectedIndex],
    );
  }
}
