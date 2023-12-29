import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() {
    return _OrdersState();
  }
}

class _OrdersState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Składanie zamówienia'),
      ),
      body: const SafeArea(
        child: Text("Orders Page"),
      ),
    );
  }
}
