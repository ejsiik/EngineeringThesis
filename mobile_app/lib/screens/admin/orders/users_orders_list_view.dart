import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';
import 'package:mobile_app/screens/admin/orders/users_orders.dart';

class UsersOrdersListView extends StatefulWidget {
  final String text;
  final IconData icon;
  final String type;
  final String id;

  const UsersOrdersListView(
      {super.key,
      required this.text,
      required this.icon,
      required this.type,
      required this.id});

  @override
  State<UsersOrdersListView> createState() {
    return _UsersOrdersListViewState();
  }
}

class _UsersOrdersListViewState extends State<UsersOrdersListView> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.scaffoldBackgroundColor;
    final Color backgroundColor = theme.brightness == Brightness.light
        ? AppColors.primaryLight
        : AppColors.primaryDark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UsersOrders(
              type: widget.type,
              id: widget.id,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Icon(
                  widget.icon,
                  size: 40,
                  color: primaryColor,
                ),
              ),
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
      ),
    );
  }
}
