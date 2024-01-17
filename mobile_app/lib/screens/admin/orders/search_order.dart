import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/constants/colors.dart';
import 'package:mobile_app/screens/user/orders_page/orders_detailed_page.dart';
import 'package:mobile_app/service/database/data.dart';
import 'package:mobile_app/service/database/order_data.dart';

class SearchOrder extends StatefulWidget {
  final String orderCode;
  const SearchOrder({super.key, required this.orderCode});

  @override
  State<SearchOrder> createState() {
    return _SearchOrderState();
  }
}

class _SearchOrderState extends State<SearchOrder> {
  OrderData orderData = OrderData();
  Data userData = Data();

  Future<String> getUsernameById(String userId) async {
    String username = await userData.getUsernameById(userId);
    return username;
  }

  Future<void> makeCompleted(String userId, String orderId) async {
    await orderData.makeCompleted(userId, orderId);
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> searchOrder(String orderCode) async {
    List<Map<String, dynamic>> data = await orderData.searchOrder(orderCode);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.brightness == Brightness.light
        ? AppColors.primaryLight
        : AppColors.primaryDark;

    return Scaffold(
      appBar: AppBar(title: Text("Wyszukane zamówienie")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: searchOrder(widget.orderCode),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Wystąpił błąd: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  "Brak zamówień",
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final orderMap = snapshot.data![index];
                final userId = orderMap.keys.first;
                final orderId = orderMap[userId]!.keys.first;
                final orderData = orderMap[userId]![orderId]!['order'];

                String city = orderData['city'];
                String street = orderData['street'];
                String streetNumber = orderData['street_number'];

                String formattedDate = DateFormat('yyyy-MM-dd HH:mm')
                    .format(DateTime.parse(orderData['order_date']));

                return Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: FutureBuilder<String>(
                      future: getUsernameById(userId),
                      builder: (context, usernameSnapshot) {
                        if (usernameSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('Pobieranie nazwy użytkownika...');
                        } else if (usernameSnapshot.hasError) {
                          return Text('Błąd: ${usernameSnapshot.error}');
                        } else {
                          return Text(
                            'Nazwa użytkownika: ${usernameSnapshot.data}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          );
                        }
                      },
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
                          'Cena całkowita: ${orderData['total_price']} zł',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Adres: $city, $street $streetNumber',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Kod odbioru: ${orderData['order_code']}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: InkWell(
                      onTap: () async {
                        await makeCompleted(userId, orderId);
                      },
                      child: Icon(
                        Icons.check,
                        color: primaryColor,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsPage(
                            order: orderData['shopping_list'],
                          ),
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
