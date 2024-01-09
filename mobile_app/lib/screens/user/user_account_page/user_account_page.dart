import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';
import 'package:mobile_app/screens/user/user_account_page/user_account_list_view.dart';
import '../../../service/authentication/auth.dart';
import 'user_settings.dart';

class UserAccountPage extends StatelessWidget {
  const UserAccountPage({super.key});

  void signOut() async {
    await Auth().signOut();
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

            // ListView
            Flexible(
              child: Container(
                color: backgroundColor,
                child: ListView(
                  children: [
                    UserAccountListView(
                        text: "Aktywne zamówienia",
                        icon: Icons.auto_stories,
                        onTap: () {}),
                    UserAccountListView(
                        text: "Zamówienia zrealizowane",
                        icon: Icons.history,
                        onTap: () {}),
                    UserAccountListView(
                        text: "Obserwowane produkty",
                        icon: Icons.remove_red_eye,
                        onTap: () {}),
                    UserAccountListView(
                        text: "Zakupione produkty",
                        icon: Icons.home_repair_service,
                        onTap: () {}),
                    UserAccountListView(
                        text: "Kupony", icon: Icons.local_offer, onTap: () {}),
                    UserAccountListView(
                        text: "Koszyk",
                        icon: Icons.add_shopping_cart,
                        onTap: () {}),
                    UserAccountListView(
                      text: "Ustawienia konta",
                      icon: Icons.settings,
                      onTap: () {
                        // Navigate to user_settings.dart when the UserAccountListView is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserSettings()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
