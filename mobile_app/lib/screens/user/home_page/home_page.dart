import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';
import '../../../authentication/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    const Color circleOpenColor = AppColors.circleOpen;
    const Color logoutColor = AppColors.logout;
    //const Color circleCloseColor = AppColors.circleClose;
    final Color primaryColor = theme.brightness == Brightness.light
        ? AppColors.primaryLight
        : AppColors.primaryDark;
    final Color textColor = theme.brightness == Brightness.light
        ? AppColors.textLight
        : AppColors.textDark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User name and logout
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    color: backgroundColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Witaj UserName ',
                              style: TextStyle(
                                fontSize: 20,
                                color: textColor,
                              ),
                            ),
                            Icon(
                              Icons.waving_hand,
                              size: 20,
                              color: primaryColor,
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.exit_to_app,
                            color: logoutColor,
                          ),
                          onPressed: () {
                            signOut();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Store location
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    color: backgroundColor,
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
                          Icons.check_circle,
                          size: 20,
                          color: circleOpenColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // User money amount
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    color: backgroundColor,
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: primaryColor,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.qr_code,
                              size: 40,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'Your Amount',
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
                ),
              ],
            ),

            // Empty container for future
            Flexible(
              child: Container(
                color: backgroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
