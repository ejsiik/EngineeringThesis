import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';
import 'package:mobile_app/constants/text_strings.dart';
import 'package:mobile_app/screens/user/orders_page/followed_products.dart';
import 'package:mobile_app/screens/user/orders_page/orders_list_page.dart';
import 'package:mobile_app/screens/user/orders_page/purchased_products.dart';
import 'package:mobile_app/service/connection/connection_check.dart';
import 'user_settings.dart';

class UserAccountListView extends StatefulWidget {
  final String text;
  final IconData icon;
  final String type;

  const UserAccountListView(
      {super.key, required this.text, required this.icon, required this.type});

  @override
  State<UserAccountListView> createState() {
    return _UserAccountListViewState();
  }
}

class _UserAccountListViewState extends State<UserAccountListView> {
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.scaffoldBackgroundColor;
    final Color backgroundColor = theme.brightness == Brightness.light
        ? AppColors.primaryLight
        : AppColors.primaryDark;

    return GestureDetector(
      onTap: () async {
        if (!await checkInternetConnectivity()) {
          _showSnackBar(connection);
        } else {
          if (widget.type == 'activeOrders' ||
              widget.type == 'completedOrders') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrdersListPage(
                  type: widget.type,
                ),
              ),
            );
          } else if (widget.type == 'purchasedProducts') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PurchasedProductsPage()),
            );
          } else if (widget.type == 'followedProducts') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FollowedProductsPage()),
            );
          } else if (widget.type == 'settings') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserSettings()),
            );
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Icon(
                  widget.icon,
                  size: 40,
                  color: primaryColor,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: 24,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
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
