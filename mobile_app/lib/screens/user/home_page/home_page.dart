import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';
import 'package:mobile_app/database/data.dart';
import 'package:mobile_app/screens/user/home_page/coupon_card.dart';
import 'package:mobile_app/screens/user/home_page/qr_code_popup.dart';
import '../../../authentication/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  void signOut() async {
    await Auth().signOut();
  }

  Future<String> getUserName() async {
    Data data = Data();
    String? userName = await data.getUserName();

    if (userName != null) {
      return userName;
    } else {
      return 'Unknown User';
    }
  }

  void openPopupScreen(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.4,
            child: const QRCodePopup(),
          ),
        );
      },
    );
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
            FutureBuilder<String>(
              future: getUserName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // or another loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  String userName = snapshot.data ?? 'Unknown User';
                  return Row(
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
                                    'Witaj $userName ',
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
                                  Icons.credit_score,
                                  color: logoutColor,
                                ),
                                onPressed: () {
                                  openPopupScreen(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
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

            const CouponCardWidget(),

            IconButton(
              icon: const Icon(
                Icons.exit_to_app,
                color: logoutColor,
              ),
              onPressed: () {
                signOut();
              },
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
