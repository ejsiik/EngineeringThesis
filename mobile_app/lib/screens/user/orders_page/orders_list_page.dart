import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/service/database/order_data.dart';
import 'package:mobile_app/screens/user/orders_page/orders_detailed_page.dart';

class OrdersListPage extends StatefulWidget {
  final String type;
  const OrdersListPage({super.key, required this.type});

  @override
  State<OrdersListPage> createState() {
    return _OrdersListState();
  }
}

class _OrdersListState extends State<OrdersListPage> {
  late Future<List<Map<String, dynamic>>> orders;

  @override
  void initState() {
    super.initState();
    // Call the function to get orders data when the widget is initialized
    orders = getOrdersData(widget.type);
  }

  Future<List<Map<String, dynamic>>> getOrdersData(String type) async {
    OrderData orderData = OrderData();
    return orderData.getOrderList(type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zamówienia'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Map<String, dynamic>> ordersList = snapshot.data ?? [];

            return ListView.builder(
              itemCount: ordersList.length,
              itemBuilder: (context, index) {
                MapEntry<String, dynamic> orderEntry =
                    ordersList[index].entries.first;
                final orderData = Map<String, dynamic>.from(
                    (orderEntry.value) as Map<Object?, Object?>);

                String city = orderData['order']['city'];
                String street = orderData['order']['street'];
                String streetNumber = orderData['order']['street_number'];

                String formattedDate = DateFormat('yyyy-MM-dd HH:mm')
                    .format(DateTime.parse(orderData['order']['order_date']));

                return Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text(
                      'Zamówienie #${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          'Data: $formattedDate',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        Text(
                          'Cena całkowita: ${orderData['order']['total_price']} zł',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Adres: $city, $street $streetNumber',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsPage(
                              order: orderData['order']['shopping_list']),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}