import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';
import 'package:mobile_app/screens/user/home_page/chat_page.dart';
import 'package:mobile_app/screens/user/shopping_cart_page/shopping_cart_page.dart';
import 'package:mobile_app/screens/user/user_account_page/user_account_page.dart';
import 'package:mobile_app/screens/user/home_page/home_page.dart';
import '/constants/config.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // Create a StreamController
  final StreamController<int> _cartUpdateController = StreamController<int>();
  final StreamController<String> _usernameController =
      StreamController<String>();

  // Create a FocusScopeNode
  late final FocusScopeNode _focusScopeNode = FocusScopeNode();

  // Method to add items to the cart
  void addItemToCart() {
    // Add an event to the stream
    _cartUpdateController.add(1);
  }

  void updateUsername(String newUsername) {
    _usernameController.add(newUsername);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color navbarSelectedColor = theme.brightness == Brightness.light
        ? AppColors.navbarSelectedLight
        : AppColors.navbarSelectedDark;
    final Color navbarUnselectedColor = theme.brightness == Brightness.light
        ? AppColors.navbarUnselectedLight
        : AppColors.navbarUnselectedDark;

    final List<Widget> pages = [
      HomePage(usernameController: _usernameController),
      const ChatPage(
        receiverId: receiverId,
        receiverEmail: receiverEmail,
      ),
      StreamBuilder<int>(
        stream: _cartUpdateController.stream,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          // Rebuild the ShoppingCartPage whenever an item is added to the cart
          return ShoppingCartPage();
        },
      ),
      const UserAccountPage(),
    ];

    return FocusScope(
      node: _focusScopeNode,
      child: Scaffold(
        appBar: AppBar(
          title: Container(),
          toolbarHeight: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: backgroundColor,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedIconTheme: IconThemeData(
            color: navbarSelectedColor,
          ),
          unselectedIconTheme: IconThemeData(
            color: navbarUnselectedColor,
          ),
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: 'Home',
              backgroundColor: backgroundColor,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.chat),
              label: 'Chat',
              backgroundColor: backgroundColor,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.add_shopping_cart),
              label: 'Shopping Cart',
              backgroundColor: backgroundColor,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: 'Profile',
              backgroundColor: backgroundColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the FocusScopeNode to avoid memory leaks
    _focusScopeNode.dispose();
    // Close the StreamController to avoid memory leaks
    _cartUpdateController.close();
    _usernameController.close();
    super.dispose();
  }
}
