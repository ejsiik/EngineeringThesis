import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';

import '../../authentication/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color? textColor = theme.textTheme.bodyLarge!.color;
    const Color circleColor = AppColors.circleLight;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(color: backgroundColor),
              Positioned(
                top: 20,
                left: 20,
                child: Row(
                  children: [
                    Text(
                      'Cześć IMIE ',
                      style: TextStyle(
                        fontSize: 20,
                        color: textColor,
                      ),
                    ),
                    Icon(
                      Icons.waving_hand,
                      size: 20,
                      color: textColor,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 50,
                left: 20,
                child: Row(
                  children: [
                    Text(
                      'Kaszubska 23, 44-100 Gliwice ',
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                    const Icon(
                      Icons
                          .check_circle, // green/red light when store is opened/closed
                      size: 20,
                      color: circleColor,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 150,
                left: 20,
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: textColor,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.qr_code, // Replace with clickable barcode icon
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Your Amount', // money spent or saved
                      style: TextStyle(fontSize: 20, color: textColor),
                    ),
                    Icon(
                      Icons.attach_money,
                      size: 30,
                      color: textColor,
                    ),
                  ],
                ),
              ),

              // Logout Button (for tests)
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: textColor,
                  ),
                  onPressed: () {
                    signOut();
                  },
                ),
              ),

              // Bottom Navigation
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: BottomNavigationBar(
                  backgroundColor: backgroundColor,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.home),
                      label: 'Home',
                      backgroundColor: backgroundColor,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.local_offer),
                      label: 'Coupons',
                      backgroundColor: backgroundColor,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.history),
                      label: 'History',
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
            ],
          ),
        ),
      ),
    );
  }
}
