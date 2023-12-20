import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';
import 'package:mobile_app/screens/user/home_page/chat_page.dart';
import '../../service/authentication/auth.dart';
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

  final pages = [
    const HomePage(),
    const ChatPage(
      receiverId: receiverId,
      receiverEmail: receiverEmail,
    ),
    const HomePage(),
    const UserAccountPage(),
  ];

  void signOut() async {
    await Auth().signOut();
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

    return SafeArea(
      child: Scaffold(
        /*
        // remember state of each page
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        */
        body: pages[_currentIndex],
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
              label: 'Trolley',
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
}
