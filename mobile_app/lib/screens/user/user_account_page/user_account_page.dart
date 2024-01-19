import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';
import 'package:mobile_app/screens/user/user_account_page/user_account_list_view.dart';
import 'package:mobile_app/service/authentication/auth.dart';
import 'package:mobile_app/service/connection/connection_check.dart';
import 'package:mobile_app/service/database/data.dart';
import 'package:shimmer/shimmer.dart';

class UserAccountPage extends StatefulWidget {
  const UserAccountPage({Key? key}) : super(key: key);

  @override
  State<UserAccountPage> createState() {
    return _UserAccountPage();
  }
}

class _UserAccountPage extends State<UserAccountPage> {
  Data data = Data();

  void signOut() async {
    await Auth().signOut();
  }

  Future<String> getUserName() async {
    if (!await checkInternetConnectivity()) {
      return "";
    }

    String? userName = await data.getUserName();

    if (userName != null) {
      return userName;
    } else {
      return 'Unknown User';
    }
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
    final Color shimmerBaseColor = theme.brightness == Brightness.light
        ? AppColors.shimmerBaseColorLight
        : AppColors.shimmerBaseColorDark;
    final Color shimmerHighlightColor = theme.brightness == Brightness.light
        ? AppColors.shimmerHighlightColorLight
        : AppColors.shimmerHighlightColorDark;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User name and logout
          FutureBuilder<String>(
            future: getUserName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Shimmer.fromColors(
                  baseColor: shimmerBaseColor,
                  highlightColor: shimmerHighlightColor,
                  child: Container(
                      width: double.infinity,
                      height: 60.0,
                      color: backgroundColor),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                String userName = snapshot.data ?? 'Brak danych';
                return AppBar(
                  backgroundColor: backgroundColor,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Witaj $userName ',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          Icon(
                            Icons.waving_hand,
                            size: 24,
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
                );
              }
            },
          ),

          // ListView
          Flexible(
            child: Container(
              color: backgroundColor,
              child: ListView(
                children: [
                  UserAccountListView(
                    text: "Aktywne zamówienia",
                    icon: Icons.auto_stories,
                    type: "activeOrders",
                  ),
                  UserAccountListView(
                    text: "Zamówienia zrealizowane",
                    icon: Icons.history,
                    type: "completedOrders",
                  ),
                  UserAccountListView(
                    text: "Zakupione produkty",
                    icon: Icons.home_repair_service,
                    type: "purchasedProducts",
                  ),
                  UserAccountListView(
                    text: "Obserwowane produkty",
                    icon: Icons.remove_red_eye,
                    type: "followedProducts",
                  ),
                  UserAccountListView(
                    text: "Ustawienia konta",
                    type: "settings",
                    icon: Icons.settings,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
