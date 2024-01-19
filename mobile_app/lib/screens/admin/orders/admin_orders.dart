import 'package:flutter/material.dart';
import 'package:mobile_app/constants/text_strings.dart';
import 'package:mobile_app/screens/admin/orders/users_orders.dart';
import 'package:mobile_app/service/connection/connection_check.dart';

class AdminOrders extends StatefulWidget {
  final String id;

  const AdminOrders({super.key, required this.id});

  @override
  State<AdminOrders> createState() {
    return _AdminOrdersState();
  }
}

class _AdminOrdersState extends State<AdminOrders> {
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zamówienia'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OrderCard(
            text: "Aktywne zamówienia",
            icon: Icons.auto_stories,
            type: "activeOrders",
            id: widget.id,
            onTap: () async {
              if (!await checkInternetConnectivity()) {
                _showSnackBar(connection);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsersOrders(
                      type: "activeOrders",
                      id: widget.id,
                    ),
                  ),
                );
              }
            },
          ),
          OrderCard(
            text: "Zamówienia zrealizowane",
            icon: Icons.history,
            type: "completedOrders",
            id: widget.id,
            onTap: () async {
              if (!await checkInternetConnectivity()) {
                _showSnackBar(connection);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsersOrders(
                      type: "completedOrders",
                      id: widget.id,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final String type;
  final String id;
  final VoidCallback onTap;

  const OrderCard({
    Key? key,
    required this.text,
    required this.icon,
    required this.type,
    required this.id,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          title: Text(text),
          leading: Icon(icon),
          trailing: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
