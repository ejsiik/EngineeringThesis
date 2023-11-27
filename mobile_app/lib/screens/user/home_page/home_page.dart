import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';
import 'package:mobile_app/database/data.dart';
import 'package:mobile_app/screens/user/home_page/coupon_card.dart';
import 'package:mobile_app/screens/user/home_page/qr_code_popup.dart';
import '../../../authentication/auth.dart';
import 'welcome_banner.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  bool showWelcomeBanner = false;
  Data data = Data();
  UserDataProvider userData = UserDataProvider();

  @override
  void initState() {
    super.initState();
    // Set up a listener for changes in the database
    userData.isUserCreatedWithin14Days().then((value) {
      setState(() {
        showWelcomeBanner = value;
      });
    });
  }

  void signOut() async {
    await Auth().signOut();
  }

  Future<String> getUserName() async {
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
    const Color logoutColor = AppColors.logout;
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
                  return const CircularProgressIndicator();
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

            // Show the WelcomeBanner only if conditions are met
            if (showWelcomeBanner)
              WelcomeBanner(
                onButtonPressed: () {
                  openPopupScreen(context);
                },
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
          ],
        ),
      ),
    );
  }
}
