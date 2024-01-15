import 'package:flutter/material.dart';
import 'package:mobile_app/screens/admin/orders/users_list.dart';
import 'chat/admin_chat.dart';
import 'home_page/home_page.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    AdminHomePage(),
    AdminChatScreen(),
    UsersList(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Start',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Czat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: 'Zamówienia',
          ),
        ],
      ),
    );
  }
}
