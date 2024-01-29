import 'package:flutter/material.dart';
import 'package:mobile_app/screens/user/user_account_page/user_account_list_view.dart';

class UserAccountPage extends StatefulWidget {
  const UserAccountPage({Key? key}) : super(key: key);

  @override
  State<UserAccountPage> createState() {
    return _UserAccountPage();
  }
}

class _UserAccountPage extends State<UserAccountPage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel użytkownika'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
